#!/bin/bash

set -e

command_exists() {
	command -v "$1" >/dev/null 2>&1
}

echo "### INSTALL NECESSARY PACKAGES ###"
sudo apt update
sudo apt install -y curl git build-essential ripgrep unzip xclip

NVIM_DIR="$HOME/.local/nvim-linux-x86_64"
NVIM_BIN="$NVIM_DIR/bin/nvim"

if ! command_exists nvim || [ ! -x "$NVIM_BIN" ]; then
	echo "### INSTALL NEOVIM ###"
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
	mkdir -p "$NVIM_DIR"
	tar -C "$HOME/.local" -xzf nvim-linux-x86_64.tar.gz
	rm nvim-linux-x86_64.tar.gz

	if ! grep -q "$NVIM_DIR/bin" ~/.bashrc; then
		echo "export PATH=\"$NVIM_DIR/bin:\$PATH\"" >> ~/.bashrc
	fi
else
	echo "Neovim already installed at $NVIM_BIN"
	nvim --version
fi

echo "### INSTALL kickstart.nvim ###"
NVIM_CONFIG_DIR="$HOME/.config/nvim"
INIT_LUA="$NVIM_CONFIG_DIR/init.lua"
if [ ! -f "$INIT_LUA" ]; then
	mkdir -p "$NVIM_CONFIG_DIR"
	curl -o "$INIT_LUA" https://raw.githubusercontent.com/vaizq/kickstart.nvim/refs/heads/master/init.lua
fi

if ! command_exists go; then
	echo "### INSTALL GO 1.24.4 ###"
	curl -LO https://go.dev/dl/go1.24.4.linux-amd64.tar.gz
	sudo rm -rf /usr/local/go
	sudo tar -C /usr/local -xzf go1.24.4.linux-amd64.tar.gz
	rm go1.24.4.linux-amd64.tar.gz

	if ! grep -q "/usr/local/go/bin" ~/.bashrc; then
		echo "export PATH=\"/usr/local/go/bin:\$PATH\"" >> ~/.bashrc
	fi

	if ! grep -q "HOME/go/bin" ~/.bashrc; then
		echo "export PATH=\"\$HOME/go/bin:\$PATH\"" >> ~/.bashrc
	fi
else
	echo "Go already installed"
	go version
fi

if ! command_exists npm; then
	echo "### INSTALLING npm and node ###"
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
	export NVM_DIR="$HOME/.nvm"
	. "$NVM_DIR/nvm.sh"
	nvm install 22
else
	echo "npm already installed"
fi

npm i -g vscode-langservers-extracted typescript typescript-language-server


if ! command_exists docker; then
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

	sudo groupadd docker
	sudo usermod -aG docker $USER
	newgrp docker
else
	echo "docker is already installed"
fi

echo "### DONE! Open a new terminal or run: source ~/.bashrc ###"
