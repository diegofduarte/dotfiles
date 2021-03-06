#!/bin/sh

echo "Setting up your Mac..."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle

# Make ZSH the default shell environment
chsh -s $(which zsh)

# Install PHP extensions with PECL
# pecl install imagick

# Install Composer
# curl -sS https://getcomposer.org/installer | php
# mv composer.phar /usr/local/bin/composer

# Install global Composer packages
# /usr/local/bin/composer global require laravel/installer laravel/spark-installer laravel/valet

# Install Laravel Valet
# $HOME/.composer/vendor/bin/valet install

# Install global NPM packages
npm install --global yarn

# Create a Sites directory
# This is a default directory for macOS user accounts but doesn't comes pre-installed
mkdir $HOME/Sites

# ZSH - Prezto =D
# http://sourabhbajaj.com/mac-setup/iTerm/zsh.html
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

# Removes .zs? from $HOME (if it exists) and symlinks the .zshrc/.zpreztorc file from the .dotfiles
rm -rf $HOME/.zshrc $HOME/.zpreztorc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc
ln -s $HOME/.dotfiles/.zpreztorc $HOME/.zpreztorc

# Restore sublime
ln -s $HOME/.dotfiles/.sublime/User $HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User

# Symlink the Mackup config file to the home directory
ln -s $HOME/.dotfiles/.mackup.cfg $HOME/.mackup.cfg

# Symlink the git config file to the home directory
rm -f $HOME/.gitconfig
ln -s $HOME/.dotfiles/.gitconfig $HOME/.gitconfig

# TODO: Configure istio brew keg
# Install istio
curl -L https://git.io/getLatestIstio | sh -
istio_base_path=$(find . -type dir -maxdepth 1 -name 'istio-*' | xargs basename)
ln -s $HOME/.dotfiles/${istio_base_path}/bin/istioctl /usr/local/bin/istioctl

# Set macOS preferences
# We will run this last because this will reload the shell
source .macos
