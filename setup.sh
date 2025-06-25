#!/bin/bash

command_exists() {
	command -v "$1" >/dev/null
}

echo "### INSTALL NECESSARY PACKAGES ###"
sudo apt update
sudo apt install curl git build-essential ripgrep unzip xclip

if ! command_exists nvim; then
	echo "\n### INSTALL NEOVIM ###"
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
	sudo rm -rf /opt/nvim-linux-x86_64
	sudo mkdir -p /opt/nvim-linux-x86_64
	sudo chmod a+rX /opt/nvim-linux-x86_64
	sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
	echo "export PATH=\"\$PATH:/opt/nvim-linux-x86_64/bin\"" >> ~/.bashrc
	rm nvim-linux-x86_64.tar.gz
else
	echo "nvim is already installed"
	nvim --version
fi

echo "### INSTALL kickstart.nvim ###"
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/
mkdir -p ~/.config/nvim
curl https://raw.githubusercontent.com/vaizq/kickstart.nvim/refs/heads/master/init.lua >> ~/.config/nvim/init.lua

if ! command_exists go; then
	echo "### INSTALL GO 1.24.4 ###"
	curl -LO https://go.dev/dl/go1.24.4.linux-amd64.tar.gz
	sudo rm -rf /usr/local/go
	sudo tar -C /usr/local -xzf go1.24.4.linux-amd64.tar.gz
	echo "export PATH=\"\$PATH:/usr/local/go/bin\"" >> ~/.bashrc
	rm go1.24.4.linux-amd64.tar.gz
else
	echo "go is already installed"
	go version
fi

echo "### DONE! Open a new terminal or call$ source ~/.bashrc to finish setup ###"
