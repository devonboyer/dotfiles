#!/bin/bash
#
# Add the following lines to ~/.bash_profile:
# source "/path/to/kubeps1.sh"
# export PS1="\u@\h \W \[\$(kube_ps1)\] $ "

# Debug
[[ -n $DEBUG ]] && set -x

_kube_ps1_symbol() {
  if ((BASH_VERSINFO[0] >= 4)) && [[ $'\u2388 ' != "\\u2388 " ]]; then
    KUBE_PS1_SYMBOL=$'\u2388 '
    KUBE_PS1_SYMBOL_IMG=$'\u2638 '
  else
    KUBE_PS1_SYMBOL=$'\xE2\x8E\x88 '
    KUBE_PS1_SYMBOL_IMG=$'\xE2\x98\xB8 '
  fi

  echo "$(tput setaf 4)${KUBE_PS1_SYMBOL}$(tput sgr0)"
}

_kube_ps1_context() {
  echo "$(cat ~/.kube/config | \
    grep "current-context:" | \
    sed "s/current-context: //")"
}

_kube_ps1_namespace() {
  echo "$(cat ~/.kube/config | \
    grep "namespace:" | \
    sed "s/namespace: //" | \
    tr -d '[:space:]')"
}

# Build prompt
kube_ps1()
{
    local KUBE_PS1

    KUBE_PS1+="$(_kube_ps1_symbol)|$(_kube_ps1_context)"

    namespace=$(_kube_ps1_namespace)

    if [ -n $namespace ]; then
        KUBE_PS1+=":$(tput setaf 36)$namespace$(tput sgr0)"
    fi

    echo "(${KUBE_PS1})"
}
