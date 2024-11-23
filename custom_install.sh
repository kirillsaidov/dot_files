#!/usr/bin/env bash

# ---
# Prepare

# start
echo ">> Preparing..."

# build and copy binary
build_bin() {
    local name=$1
    cd $name
    dub build
    cp bin/$name $HOME/myfiles/system/bin
    cd ..
}

# create variables for usage
ci_mkdir_folders=()
ci_installed=()

# create a temporary custom_installs folder
ci_mkdir_folders+=("$HOME/myfiles/tmp/custom_installs")
echo ">> Create temporary directory: ${ci_mkdir_folders[-1]}"
mkdir -p ${ci_mkdir_folders[-1]}
cd ${ci_mkdir_folders[-1]}

# ---
# Install custom apps

# --- dlang
ci_installed+=("dlang")
echo ">> Install ${ci_installed[-1]}..."
wget -O dlang.deb "https://downloads.dlang.org/releases/2.x/2.109.1/dmd_2.109.1-0_amd64.deb"
sudo dpkg -i dlang.deb
sudo apt install -f -y

# --- img2pdf
ci_installed+=("img2pdf")
echo ">> Install ${ci_installed[-1]}..."
git clone https://github.com/rillki/img2pdf.git
build_bin ${ci_installed[-1]}

# --- ymt
ci_installed+=("ymt")
echo ">> Install ${ci_installed[-1]}..."
sudo apt install -y libsqlite3-dev libcairo2-dev
git clone https://github.com/rillki/ymt.git
build_bin ${ci_installed[-1]}

# --- dsync
ci_installed+=("dsync")
echo ">> Install ${ci_installed[-1]}..."
git clone https://github.com/rillki/dsync.git
build_bin ${ci_installed[-1]}

# --- zippo
ci_installed+=("zippo")
echo ">> Install ${ci_installed[-1]}..."
git clone https://github.com/rillki/zippo.git
build_bin ${ci_installed[-1]}

# ---
# Print summary

cat <<EOF
>> Info:
    1. $HOME/myfiles/tmp/custom_install folder was created. Remove it manually if neccessary.
    2. Installed: ${ci_installed[@]}
>> Done.
EOF
