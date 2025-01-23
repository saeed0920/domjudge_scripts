#!/bin/bash
# setup domjudge ,generate password
set -e

FilePath="/passwords.txt"
touch $FilePath
writeFile() 
{
 echo "" >> $FilePath
 echo $@ >> $FilePath
}

generate_randomPassword() 
{
  local password=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 10)
  echo "$password"
}

mysqlRootPassword=$(generate_randomPassword)
mysqlPassword=$(generate_randomPassword)


### mariadb
#docker run -it --restart unless-stopped --name dj-mariadb -e MYSQL_ROOT_PASSWORD=$mysqlRootPassword -e MYSQL_USER=domjudge -e MYSQL_PASSWORD=$mysqlPassword -e MYSQL_DATABASE=domjudge -p 13306:3306 mariadb --max-connections=1000 --innodb-log-file-size=2G --max-allowed-packet=1G

### MariaDB setup
docker run -dit --restart unless-stopped --name dj-mariadb \
  -e MYSQL_ROOT_PASSWORD="$mysqlRootPassword" \
  -e MYSQL_USER=domjudge \
  -e MYSQL_PASSWORD="$mysqlPassword" \
  -e MYSQL_DATABASE=domjudge \
  -p 13306:3306 mariadb \
  --max-connections=1000 \
  --innodb-log-file-size=2G \
  --max-allowed-packet=1G

echo $mysqlRootPassword 
echo $mysqlPassword
writeFile "mysqlRootPassword: $mysqlRootPassword "
writeFile "mysqlPassword: $mysqlPassword "


echo "Waiting for MariaDB to be ready..."
until docker exec dj-mariadb mariadb -u root -p"$mysqlRootPassword"; do
  sleep 2
done
echo "MariaDB is ready!"

### domserver
docker run --link dj-mariadb:mariadb -it -e MYSQL_HOST=mariadb \ 
  -e MYSQL_USER=domjudge \ 
  -e MYSQL_DATABASE=domjudge \
  -e MYSQL_PASSWORD=$mysqlPassword \ 
  -e MYSQL_ROOT_PASSWORD=$mysqlRootPassword \ 
  -p 80:80 \
  --name domserver domjudge/domserver:latest

echo "Waiting for Domjudge server to be ready..."
until curl -s 127.0.0.1:80 > /dev/null; do
  sleep 2
done
echo "Domjudge server is ready!"

admin_password=$(docker exec -it domserver cat /opt/domjudge/domserver/etc/initial_admin_password.secret)
judgehost_password=$(docker exec -it domserver cat /opt/domjudge/domserver/etc/restapi.secret)

writeFile "admin_password ${admin_password}"
writeFile "judgehost_password ${judgehost_password}"


read "Pls input the number of judgeHosts!" judgehost_number
for (( c=0; c<$judgehost_number; c++ ))
do
# JudgeHost 
docker run -it --privileged \ 
 -v /sys/fs/cgroup:/sys/fs/cgroup \
 --name judgehost-$item --link domserver:domserver \
 --hostname judgedaemon-$c \
 -e DAEMON_ID=$c \ 
 -e JUDGEDAEMON_PASSWORD="$judgehost_password" domjudge/judgehost:latest
done

