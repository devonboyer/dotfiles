#!/bin/bash
#
# Add the following lines to ~/.bash_profile:
# source "/path/to/kubectx.sh"

kubectx() {
    kubectl config set-context $1
}

kubens() {
    kubectl config set-context $(kubectl config current-context) --namespace=$1
}
