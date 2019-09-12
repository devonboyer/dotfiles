#!/bin/bash
#
# Add the following lines to ~/.bash_profile:
# source "/path/to/kubectx.sh"

kubectx() {
    kubectl config use-context $1
}

kubens() {
    kubectl config use-context $(kubectl config current-context) --namespace=$1
}
