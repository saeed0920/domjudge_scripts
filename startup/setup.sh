#!/usr/bin/bash

PARAMETERS="systemd.unified_cgroup_hierarchy=0 cgroup_enable=memory swapaccount=1"
username=saeed
password=pk7zdSV784Ad

echo "This script working on debian bases ,pls use ubuntu on server!"

useradd -m -s /bin/bash "$username"
echo "$username:$password" | chpasswd

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

# pull domjudge_server domjudge_judgehost mariadb
docker pull focker.ir/mariadb 
docker pull focker.ir/domjudge/domserver:latest 
docker pull focker.ir/domjudge/judgehost:latest


# Define the parameters to add
# Backup the original grub file
cp /etc/default/grub /etc/default/grub.bak
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
