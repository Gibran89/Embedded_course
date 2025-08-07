#!/bin/bash
set -e

# ============================================
# BeagleBone Black Development Environment Setup
# Automates VS Code, Docker, and extension setup
# ============================================

# Configuration
REQUIRED_EXTENSIONS=(
    "ms-vscode-remote.remote-ssh"
    "ms-vscode-remote.remote-containers"
    "ms-azuretools.vscode-docker"
    "amiralizadeh9480.linux-device-tree"
    "ms-vscode.cpptools"
)

# System Update
echo "[1/4] Updating system packages..."
sudo apt-get update && sudo apt-get upgrade -y

# VS Code Installation
if ! command -v code &>/dev/null; then
    echo "[2/4] Installing VS Code..."
    sudo apt-get install -y wget gpg
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt-get update
    sudo apt-get install -y code
else
    echo "[2/4] VS Code already installed, skipping..."
fi

# Docker Installation
if ! command -v docker &>/dev/null; then
    echo "[3/4] Installing Docker..."
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    # Add current user to docker group
    sudo usermod -aG docker $USER
    newgrp docker
else
    echo "[3/4] Docker already installed, skipping..."
fi

# VS Code Extensions
echo "[4/4] Managing VS Code extensions..."
INSTALLED_EXTENSIONS=$(code --list-extensions)

for extension in "${REQUIRED_EXTENSIONS[@]}"; do
    if ! echo "$INSTALLED_EXTENSIONS" | grep -q "$extension"; then
        echo "Installing extension: $extension"
        code --install-extension "$extension" --force > /dev/null
    else
        echo "Extension already installed: $extension"
    fi
done

# Post-installation
echo "✅ Setup completed successfully!"
echo "Recommended actions:"
echo "1. Restart your terminal session"
echo "2. Verify Docker access: docker run hello-world"
echo "3. Open VS Code and check installed extensions"
