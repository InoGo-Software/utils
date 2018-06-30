#!/bin/bash

sudo apt update -y
sudo apt upgrade -y

sudo apt install -y zsh git vim

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Copy zsh config
cp ./.zshrc ~/.zshrc
sed -i 's/REPLACE_USER/'"$USER"'/g' ~/.zshrc

# Install zsh autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/plugins/zsh-autosuggestions

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
source ~/.zshrc