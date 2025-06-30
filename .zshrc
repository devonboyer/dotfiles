export GOPATH=$HOME
export PATH=$PATH:$(go env GOPATH)/bin
export PATH=$PATH:$HOME/google-cloud-sdk/bin

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/devonboyer/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/devonboyer/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/devonboyer/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/devonboyer/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

export EDITOR="code --wait"
export KUBECTL_EXTERNAL_DIFF=colordiff

autoload -Uz compinit
compinit

# Enable kubectl autocompletion
if command -v kubectl > /dev/null; then
    source <(kubectl completion zsh)
    # Make completion work with the 'k' alias
    compdef __start_kubectl k
fi

# Kubernetes context in prompt (zsh version)
kube_ps1() {
    local ctx=$(kubectl config current-context 2>/dev/null)
    local ns=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
    if [ -n "$ctx" ]; then
        echo -n " ⎈ $ctx"
        if [ -n "$ns" ] && [ "$ns" != "default" ]; then
            echo -n ":$ns"
        fi
    fi
}

# Git branch in prompt
git_branch() {
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        echo -n " $branch"
    fi
}

setopt PROMPT_SUBST

RPROMPT='%F{cyan}$(git_branch)%f%F{yellow}$(kube_ps1)%f'
PROMPT='%F{green}%n%f %F{blue}%~%f %% '
