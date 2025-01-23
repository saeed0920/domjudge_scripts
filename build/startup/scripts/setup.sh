#!/usr/bin/bash

echo "Should run In Ubuntu-server distro"
sleep 5
# this parameters for update the grub for cgroup v1
PARAMETERS="systemd.unified_cgroup_hierarchy=0 cgroup_enable=memory swapaccount=1"

read -p "enter the username: " username
read -p "enter the password for user saeed: " password

echo "This script working on debian bases ,pls use ubuntu on server!"

useradd -m -s /bin/bash "$username"
echo "$username:$password" | chpasswd
usermod -aG sudo $username

# setup for domjudge
apt update && apt upgrade -y
apt install nginx vim ca-certificates curl wget -y

# setup docker
# Add Docker's official GPG key:
install -m 0755 -d /etc/apt/keyrings -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
   tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update && apt update
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
groupadd docker
usermod -aG docker $username


## TODO
# installing aws and config that!
# this data going to public repo!!!!!
# docker login!
# add secret file in gitIgnore

# pull domjudge_server domjudge_judgehost mariadb
# Also we can use AbrArvan insted of focker
docker pull mariadb 
docker pull domjudge/domserver:latest 
docker pull domjudge/judgehost:latest


# Deetc/default/grub /etc/default/grub.bak
# Check if the GRUB_CMDLINE_LINUX line exists
if grep -q "^GRUB_CMDLINE_LINUX=" /etc/default/grub 
then
    # Append the parameters to the existing line
    sed -i "s|^GRUB_CMDLINE_LINUX=\"|&$PARAMETERS |" /etc/default/grub
else
    # If the line does not exist, create it
    echo GRUB_CMDLINE_LINUX="$PARAMETERS"
fi


apt install update-grub
update-grub

echo "Pls reboot the server!"
