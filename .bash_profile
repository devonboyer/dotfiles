# UWaterloo Linux machines
alias ssh-uwaterloo='ssh -Y d2boyer@linux.student.cs.uwaterloo.ca'
alias sshfs-uwaterloo='mkdir -p ~/uwaterloo && sshfs d2boyer@linux.student.cs.uwaterloo.ca:/u5/d2boyer ~/uwaterloo'
alias ssh-ubuntu1404='ssh -Y d2boyer@ubuntu1404.student.cs.uwaterloo.ca'
alias sshfs-db2='mkdir -p ~/uwaterloo && sshfs d2boyer@ubuntu1604-006.student.cs.uwaterloo.ca:/u5/d2boyer ~/uwaterloo'
alias ssh-db2='ssh -Y d2boyer@ubuntu1604-006.student.cs.uwaterloo.ca'

# Setup GOPATH
export GOPATH=$HOME
export PATH=$PATH:$(go env GOPATH)/bin
export GOPATH=$(go env GOPATH)

# Set VS Code as default editor
export EDITOR=$(code --wait)
