### 🧰 DOMjudge Setup Scripts
These scripts help automate the setup of DOMjudge — a system for running programming contests — on a self-hosted Ubuntu Server environment using Docker.

### 📁 Contents
setup.sh – Prepares a fresh Ubuntu server for running DOMjudge (installs Docker, sets up a user, pulls necessary images).

start.sh – Starts and configures the DOMjudge containers (MariaDB, domserver, judgehosts) and generates random secure passwords.

<hr>

⚙️ Requirements
- Ubuntu Server (tested on 20.04+)
- bash
- sudo access
- Internet connection

Docker (installed via Snap in this setup)

<hr>

🔧 Usage
1. Initial System Setup
Run this on a fresh Ubuntu server to set up a user and required packages:

- bash

```bash
sudo bash setup.sh
```

#### You’ll be prompted to:
- enter a username and password for a new sudo user. The script:
- Installs essential packages (Nginx, Zsh, etc.)
- Installs Docker using Snap
- Configures Docker to use ArvanCloud as a registry mirror
- Pulls DOMjudge and MariaDB images
- Adds GRUB parameters for cgroup compatibility
- Suggests a system reboot after completion

<hr>

2. Start DOMjudge Services
After reboot, run:

- bash
```bash
sudo bash start.sh
```
#### You’ll be prompted to:

- Enter how many judge hosts to run
- Choose a port for the DOMjudge server

#### The script:
-  Starts MariaDB with randomly generated passwords
-  Starts the DOMjudge server container
- Retrieves initial admin and judgehost passwords
- Spins up the specified number of judgehost containers
Saves all credentials in a file: passwords_domjudge.txt


> **_📄 Notes:_** 
The script overwrites /etc/resolv.conf with specific DNS servers (10.202.10.10 and 10.202.10.11). Adjust this to your environment.

Ensure port conflicts are avoided when selecting the DOMjudge server port.

Passwords are saved in plain text — secure the passwords_domjudge.txt file accordingly.

Currently, Docker is installed via Snap. You can modify the script to install it via APT if preferred (APT setup is commented out) but it going to change!

<hr>

#### 🚧 TODO
- [ ] Add AWS CLI setup
- [ ] Secure Docker login with secrets
- [ ] Use .gitignore to exclude sensitive config files
- [ ] Explore replacing DockerHub pulls with ArvanCloud or other mirrors for all images
- [ ] Installing with apt
- [ ] Can run on Redhat bases

##### Feel free to open an issue or PR if you find a bug or want to contribute!
