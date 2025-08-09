#!/bin/bash

echo "Checking and installing Homebrew packages..."

brew_install() {
    local pkg="$1"
    local cask=""
    if [ "$1" = "--cask" ]; then
        cask="--cask"
        pkg="$2"
    fi
    
    if ! brew list $cask "$pkg" &>/dev/null; then
        echo "Installing $pkg..."
        brew install $cask "$pkg"
    else
        echo "✓ $pkg already installed"
    fi
}

# Terminal
brew_install --cask ghostty

# Kubernetes tools
brew_install kubectl
brew_install kubecolor
brew_install krew

# Git and development tools
brew_install colordiff

# Search and file tools
brew_install fzf
brew_install fd
brew_install fzy

# Shell and completion
brew_install zsh-completions

# Google Cloud SDK
brew_install --cask google-cloud-sdk

echo ""
echo "✓ All packages checked"
echo ""
echo "Don't forget to:"
echo "  - Install kubectl plugins via krew"
echo "  - Set up fzf: $(brew --prefix)/opt/fzf/install"
