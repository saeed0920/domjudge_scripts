# ⚙️ DOMjudge Setup & Utility Scripts

This repository contains Bash scripts to help you install, run, and manage a self-hosted [DOMjudge](https://www.domjudge.org/) system using Docker on Ubuntu Server, along with a small utility to rename files easily in bulk.


## 🔧 Setup & Start Scripts

Found under: `script/main/`

These two scripts are designed to install necessary packages, configure Docker, and pull & launch DOMjudge containers (domserver, judgehosts, and MariaDB) on an Ubuntu server.

### 🛠 `setup.sh`

- Installs required tools (Docker via Snap, Nginx, Zsh, etc.)
- Adds new sudo user
- Configures Docker to use ArvanCloud mirrors
- Pulls required images: `mariadb`, `domjudge/domserver`, and `domjudge/judgehost`
- Adds cgroup parameters to GRUB for proper Docker behavior
- Prompts for system reboot

### 🚀 `start.sh`

- Starts MariaDB container with randomly generated credentials
- Starts DOMjudge server on a port of your choice
- Automatically pulls initial admin and judgehost credentials from the container
- Spawns judgehost containers based on user input
- Saves all credentials into `passwords_domjudge.txt`

---

## ✂️ Rename Script

This is a utility script to rename all files matching a specific suffix (e.g., `.txt`) to another suffix (e.g., `.in`) in the current directory.

---

## 🚩 Problems Script

This script should run in root of problems directorys! 
Each directory should has basic statement for problems in domjudge : see the example of problems in "../examples/problems"
Then each in and out directory rename file and move into the sample and secret directory
make sure the sample directory has file!
