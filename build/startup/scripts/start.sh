#!/bin/bash
# Setup DOMjudge and generate passwords

set -e

# File to store generated passwords
FilePath="/passwords.txt"
touch $FilePath
echo "" > $FilePath

# Function to write to the password file
writeFile() {
  echo "" >> $FilePath
  echo $@ >> $FilePath
}

# Function to generate a random password
generate_randomPassword() {
  local password=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 10)
  echo "$password"
}

# Generate MySQL root and user passwords
mysqlRootPassword=$(generate_randomPassword)
mysqlPassword=$(generate_randomPassword)

# Get the number of judge hosts from the user
read -p "Please input the number of judge hosts: " judgehost_number

# Start MariaDB container
docker run -dit --restart unless-stopped --name dj-mariadb \
  -e MYSQL_ROOT_PASSWORD="$mysqlRootPassword" \
  -e MYSQL_USER=domjudge \
  -e MYSQL_PASSWORD="$mysqlPassword" \
  -e MYSQL_DATABASE=domjudge \
  -p 13306:3306 mariadb \
  --max-connections=1000 \
  --innodb-log-file-size=2G \
  --max-allowed-packet=1G

# Output MySQL passwords and write them to the file
echo $mysqlRootPassword 
echo $mysqlPassword
writeFile "mysqlRootPassword: $mysqlRootPassword"
writeFile "mysqlPassword: $mysqlPassword"

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
until docker exec dj-mariadb mariadb -u root -p"$mysqlRootPassword"; do
  sleep 2
done
echo "MariaDB is ready!"

# Start DOMjudge server container
docker run -dit \
  --restart unless-stopped \
  --link dj-mariadb:mariadb \
  -it \
  -e MYSQL_HOST=mariadb \
  -e MYSQL_USER=domjudge \
  -e MYSQL_DATABASE=domjudge \
  -e MYSQL_PASSWORD=$mysqlPassword \
  -e MYSQL_ROOT_PASSWORD=$mysqlRootPassword \
  -p 80:80 \
  --name domserver \
  domjudge/domserver:latest

# Wait for DOMjudge server to be ready
echo "Waiting for DOMjudge server to be ready..."
until curl -s 127.0.0.1:80 > /dev/null; do
  sleep 2
done
echo "DOMjudge server is ready!"

# Retrieve admin and judgehost passwords from the DOMjudge server
admin_password=$(docker exec -it domserver cat /opt/domjudge/domserver/etc/initial_admin_password.secret)
judgehost_password=$(docker exec -it domserver cat /opt/domjudge/domserver/etc/restapi.secret | awk '/judgehost/ {print $4}')

# Write admin and judgehost passwords to the file
writeFile "admin_password ${admin_password}"
writeFile "judgehost_password ${judgehost_password}"

# Start judge host containers
for (( c=0; c<$judgehost_number; c++ ))
do
  docker run -dit --privileged \
    -v /sys/fs/cgroup:/sys/fs/cgroup \
    --name judgehost-$c \
    --link domserver:domserver \
    --hostname judgedaemon-$c \
    -e DAEMON_ID=$c \
    -e JUDGEDAEMON_PASSWORD="$judgehost_password" \
    domjudge/judgehost:latest
done