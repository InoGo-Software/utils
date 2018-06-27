sudo apt update -y
sudo apt upgrade -y

sudo apt install zsh git vim

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Copy zsh config
cp ./.zshrc ~/.zshrc
sed -i 's/REPLACE_USER/'"$USER"'/g' ~/.zshrc
sudo apt install -y zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Copy vim config
cp ./.vimrc ~/.vimrc


# Create the required directories
mkdir -p "~/.vim" "~/.vim/autoload" "~/.vim/bundle" "~/.vim/colors"
yes "" | vim +PlugInstall +qall

chsh -s /bin/zsh
