# Load aliases
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Setup GOPATH
export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin

# Set VS Code as default editor
export EDITOR='code --wait'

# Git branch in prompt
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Customize prompt
if [ -f "path/to/kube-ps1.sh" ]; then
  source "path/to/kube-ps1.sh"
  export PS1="\u@\h \W \$(kube_ps1) $ "                                   # Kubernetes context and namespace
else
  export PS1="\u@\h \W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "    # git branch
fi
