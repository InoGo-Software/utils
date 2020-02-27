#!/bin/bash

sudo apt update -y
sudo apt upgrade -y

sudo apt install -y zsh git vim curl wget python

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Copy zsh config
cp ./.zshrc ~/.zshrc
sed -i 's/REPLACE_USER/'"$USER"'/g' ~/.zshrc

# Install zsh autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install zsh syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Copy vim config
cp ./.vimrc ~/.vimrc

# Create the required directories
mkdir -p ~/.vim ~/.vim/autoload ~/.vim/bundle ~/.vim/colors

# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install vim plugins
yes "" | vim +PlugInstall +qall

# Copy the color scheme
cp "$HOME/.vim/bundle/dracula/autoload/dracula.vim" "$HOME/.vim/autoload/"
cp "$HOME/.vim/bundle/dracula/colors/dracula.vim" "$HOME/.vim/colors/"

# Set zsh as the default shell
chsh -s /bin/zsh

# Source .zshrc to update the zsh configuration
# shellcheck source=/dev/null
source ~/.zshrc

# Install spaceship theme
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

# Install docker
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

sudo groupadd docker
sudo usermod -aG docker $USER