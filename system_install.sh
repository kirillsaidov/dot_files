#!/usr/bin/bash

# setup variables
HELP=${HELP:-0}
SKIP_OLLAMA=${SKIP_OLLAMA:-0}
SKIP_DOCKER=${SKIP_DOCKER:-0}
SKIP_MONGO=${SKIP_MONGO:-0}

# usage
if [ "$HELP" -eq 1 ]; then
    cat <<EOF
USAGE: system_install.sh
    SKIP_OLLAMA   {0, 1} Do not install ollama. Default=0.
    SKIP_DOCKER   {0, 1} Do not install docker. Default=0.
    SKIP_MONGO    {0, 1} Do not install mongo. Default=0.
    HELP          {0, 1} This help manual. Default=0.
EOF
    exit 0
fi

# update system
echo ">>> Updating and upgrading system..."
sudo apt update && sudo apt upgrade -y

# install necessary command line utilities
echo ">>> Installing command line utilities..."
sudo apt install -y build-essential git vim htop neofetch curl wget apt-transport-https ca-certificates ffmpeg python3-pip python3-venv

# install apps
echo "Installing relevant apps..."
sudo apt install -y tilix vlc audacity shotcut darktable

# --- vscode
wget -O vscode-linux.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
sudo dpkg -i ./vscode-linux.deb
sudo apt install -f -y

# --- sublime text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update && sudo apt install -y sublime-text

# --- megasync
wget -O megasync.deb https://mega.nz/linux/repo/xUbuntu_24.04/amd64/megasync-xUbuntu_24.04_amd64.deb
sudo dpkg -i ./megasync.deb
sudo apt install -f -y 

# --- docker
if [ "$SKIP_DOCKER" -eq 0 ]; then
    # install docker
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker $USER
    
    # configure docker logs size
    sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "10m",
        "max-file": "3"
    }
}
EOF
fi

# --- mongo
if [ "$SKIP_MONGO" -eq 0 ]; then
    # install mongo with docker
    sudo docker pull mongodb/mongodb-community-server:latest
    sudo docker run --name mongodb -p 27017:27017 -d mongodb/mongodb-community-server:latest
    sudo docker update --restart unless-stopped $(sudo docker ps -aqf "name=mongodb")

    # install mongo compass
    wget -O mongo-compass.deb "https://downloads.mongodb.com/compass/mongodb-compass_1.44.7_amd64.deb"
    sudo dpkg -i ./mongo-compass.deb
    sudo apt install -f -y 
fi

# --- ollama
if [ "$SKIP_OLLAMA" -eq 0 ]; then
    curl -fsSL https://ollama.com/install.sh | sh
fi

# cleanup
trap 'rm -f vscode-linux.deb megasync.deb mongo-compass.deb install.sh' EXIT

