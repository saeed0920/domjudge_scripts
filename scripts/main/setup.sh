#!/usr/bin/bash

# functions
checkValid() 
{
if [ $1 -ge 1 ]; then
  echo "Script recived error"
  exit $1
fi
}

echo "Should run In Ubuntu-server Distro"
sleep 5
# this parameters for update the grub for cgroup v1
PARAMETERS="systemd.unified_cgroup_hierarchy=0 cgroup_enable=memory swapaccount=1"

read -p "enter the username: " username
read -p "enter the password for user $username : " password

echo "This script working on debian bases ,pls use ubuntu on server!"

useradd -m -s /bin/bash "$username"
echo "$username:$password" | chpasswd
usermod -aG sudo $username

# setup for domjudge
apt update && apt upgrade -y
apt install nginx snapd vim zsh ca-certificates curl wget update-grub -y

echo "Check if snap installed"
snap install hello-world
checkValid $?

cat "78.157.42.101" > /etc/resolv.conf
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

groupadd docker
usermod -aG docker $username


## TODO
# installing aws and config that!
# this data going to public repo!!!!!
# docker login!
# add secret file in gitIgnore

# pull domjudge_server domjudge_judgehost mariadb
# Also we can use AbrArvan insted of focker
# Use AbrArvan for pulling img
bash -c 'cat > /etc/docker/config/daemon.json <<EOF
{
  "insecure-registries" : ["https://docker.arvancloud.ir"],
  "registry-mirrors": ["https://docker.arvancloud.ir"]
}
EOF'


while [ true ]
do
  sleep 1
  docker run hello-world
  if [ $? -eq 0 ]; then
    break
  fi
done

checkValid $?
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
