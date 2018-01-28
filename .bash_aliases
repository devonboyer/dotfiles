export UW_USERID='d2boyer'

ssh_uwaterloo () { ssh -Y $UW_USERID@linux.student.cs.uwaterloo.ca; }

sshfs_uwaterloo () { sshfs $UW_USERID@linux.student.cs.uwaterloo.ca:/u5/$UW_USERID $1 &> /dev/null; }

# UWaterloo undergrad environment
alias sshuw='ssh_uwaterloo'
alias sshfsuw='mkdir -p ~/uwaterloo && sshfs_uwaterloo ~/uwaterloo'
alias uw='sshuw'

# 3B courses
alias cs343='cd ~/uwaterloo/cs343 && code .'
alias cs454='cd ~/uwaterloo/cs454 && code .'
alias cs456='cd ~/uwaterloo/cs456 && code .'
