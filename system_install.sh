#!/usr/bin/bash

# setup variables
HELP=${HELP:-0}
SKIP_OLLAMA=${SKIP_OLLAMA:-0}

# usage
if [ "$HELP" -eq 1 ]; then
    cat <<EOF
USAGE: system_install.sh
    SKIP_OLLAMA   {0, 1} Do not install ollama. Default=0.
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
sudo apt install -y audacity tilix

# --- vscode
wget -O vscode-linux.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
sudo apt install vscode-linux.deb
rm vscode-linux.dev

# --- sublime text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update && sudo apt install -y sublime-text

# --- docker
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER

# --- ollama
if [ "$SKIP_OLLAMA" -eq 0 ]; then
    curl -fsSL https://ollama.com/install.sh | sh
fi



