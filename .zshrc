autoload -Uz compinit
compinit

# load dev, but only if present and the shell is interactive
if [[ -f /opt/dev/dev.sh ]] && [[ $- == *i* ]]; then
  source /opt/dev/dev.sh
fi

[[ -f /opt/dev/sh/chruby/chruby.sh ]] && { type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; } }

[[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)

# cloudplatform: add Shopify clusters to your local kubernetes config
export KUBECONFIG=${KUBECONFIG:+$KUBECONFIG:}/Users/devonboyer/.kube/config:/Users/devonboyer/.kube/config.shopify.cloudplatform
for file in /Users/devonboyer/src/github.com/Shopify/cloudplatform/workflow-utils/*.bash; do source ${file}; done

export GOPATH=$HOME
export PATH=$PATH:$(go env GOPATH)/bin
export PATH=$PATH:$HOME/google-cloud-sdk/bin
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/devonboyer/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/devonboyer/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/devonboyer/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/devonboyer/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

export EDITOR="code --wait"
export KUBECTL_EXTERNAL_DIFF=colordiff

alias kubectl="kubecolor"
alias k="kubectl"

# Enable kubectl autocompletion
if command -v kubectl > /dev/null; then
    source <(kubectl completion zsh)
    # Make completion work with the 'k' alias
    compdef __start_kubectl k
fi

if [[ -x $HOME/bin/kubectl-pi ]]; then source <($HOME/bin/kubectl-pi completion zsh); fi

# Kubernetes context in prompt (zsh version)
kube_ps1() {
    local ctx=$(kubectl config current-context 2>/dev/null)
    local ns=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
    if [ -n "$ctx" ]; then
        echo -n " %F{yellow}⎈ $ctx%f"
        if [ -n "$ns" ] && [ "$ns" != "default" ]; then
            echo -n ":%F{blue}$ns%f"
        fi
    fi
}

git_branch() {
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        if [ ${#branch} -gt 20 ]; then
            branch="${branch:0:17}..."
        fi
        echo -n " $branch"
    fi
}

source ~/.gitprompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUPSTREAM="verbose"
GIT_PS1_SHOWCOLORHINTS=1

git_status_symbols() {
    local git_string=$(__git_ps1 "%s" 2>/dev/null)
    if [ -n "$git_string" ]; then
        # Extract status symbols: *, +, $, %, <, >, etc.
        local symbols=$(echo "$git_string" | sed -E 's/^[^ ]+ ?//')
        if [ -n "$symbols" ]; then
            echo -n " $symbols"
        fi
    fi
}

setopt PROMPT_SUBST

RPROMPT='%F{cyan}$(git_branch)%f%F{yellow}$(kube_ps1)%f'
#PROMPT='%(?.%F{gray}.%F{red})%?%f %F{green}%n%f %F{blue}%~%f%F{yellow}$(git_status_symbols)%f %% '
PROMPT='%(?.%F{gray}.%F{red})%?%f %F{green}%n%f %F{blue}%~%f %% '

function - {
    cd - &> /dev/null
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=dark
--layout=reverse
--height=40%
'

# Taken from https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
__fzfcmd() {
    [ -n "$TMUX_PANE" ] && { [ "${FZF_TMUX:-0}" != 0 ] || [ -n "$FZF_TMUX_OPTS" ]; } &&
        echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
    }
# CTRL-R - Paste the selected command from history into the command line
fzf-history-widget() {
    local selected num
    setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
    selected=( $(fc -rl 1 | perl -ne 'print if !$seen{(/^\s*[0-9]+\**\s+(.*)/, $1)}++' |
        FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort,ctrl-z:ignore $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
            local ret=$?
            if [ -n "$selected" ]; then
                num=$selected[1]
                if [ -n "$num" ]; then
                    zle vi-fetch-history -n $num
                fi
            fi
            zle reset-prompt
            return $ret
        }
    zle -N fzf-history-widget
    bindkey '^R' fzf-history-widget

JUMPDIR_KEYBIND='jd '
# Setup some data a data file to store visited directories
mkdir -p "$XDG_DATA_HOME/zshrc"
JD_DATA_DIR="$XDG_DATA_HOME/zshrc/chpwd.txt"
touch $JD_DATA_DIR
local tmp=$(mktemp)
cat $JD_DATA_DIR | while read dir ; do [[ -d $dir ]] && echo $dir ; done > $tmp
cat $tmp > $JD_DATA_DIR
# Track visited directories
chpwd_functions+=(on_chpwd)
function on_chpwd {
    local tmp=$(mktemp)
    { echo $PWD ; cat $JD_DATA_DIR } | sort | uniq 1> $tmp
    cat $tmp > $JD_DATA_DIR
}
# zle widget function
function fzy_jd {
    # check if `jd ` was triggered in the middle of another command
    # e.g. $ aaaaaaajd 
    # If so, we manually input the `jd `
    if [[ ! -z $BUFFER ]]; then
        # Append `jd ` to the prompt
        BUFFER=$BUFFER$JUMPDIR_KEYBIND
        # move the cursor to the end of the line
        zle end-of-line
        return 0
    fi
    # ask the user to select a directory to jump to
    local dir=$({ echo $HOME ; cat $JD_DATA_DIR } | fzy)
    if [[ -z $dir ]]; then
        # no directory was selected, reset the prompt to what it was before
        zle reset-prompt
        return 0
    fi
    # Setup the command to change the directory
    BUFFER="cd $dir"
    # Accepts the cd we setup above
    zle accept-line
    local ret=$?
    # force the prompt to redraw to mimic what would occur with a normal cd
    zle reset-prompt
    return $ret
}
# define the new widget function
zle -N fzy_jd
# bind the widget function to `jd `
bindkey $JUMPDIR_KEYBIND fzy_jd
# a nicety so that executing just jd will mimic the behaviour of just executing
# cd, that is, change the pwd to $HOME
eval "alias $(echo $JUMPDIR_KEYBIND|xargs)=cd"

function fzy_path {
    LBUFFER="$LBUFFER$(fd . | fzy)"
    zle reset-prompt
}
zle -N fzy_path
bindkey '^T' fzy_path

alias src='source ~/.zshrc'
alias zc='code ~/.zshrc'
alias g="git"
alias tf="terraform"
alias kpb="k pi cur | pbcopy"
alias gtms="gt co main && gt sync"
alias gts="gt sync"
