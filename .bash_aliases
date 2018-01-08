export UW_USERID='d2boyer'

ssh_uwaterloo () { ssh -Y $UW_USERID@linux.student.cs.uwaterloo.ca; }

sshfs_uwaterloo () { sshfs $UW_USERID@linux.student.cs.uwaterloo.ca:/u5/$UW_USERID $1 &> /dev/null; }

# UWaterloo undergrad environment
alias sshuw='ssh_uwaterloo'
alias sshfsuw='mkdir -p ~/uwaterloo && sshfs_uwaterloo ~/uwaterloo && cd ~/uwaterloo'
alias uw='sshfsuw && sshuw'
