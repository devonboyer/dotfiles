export UW_USERID='d2boyer'

ssh_uwaterloo () { ssh -Y $UW_USERID@$1.student.cs.uwaterloo.ca; }

sshfs_uwaterloo () { sshfs $UW_USERID@linux.student.cs.uwaterloo.ca:/u5/$UW_USERID $1 &> /dev/null; }

# UWaterloo undergrad environment
alias um='umount -f ~/uwaterloo'
alias sshuw='ssh_uwaterloo linux'
alias sshfsuw='um &> /dev/null && mkdir -p ~/uwaterloo && sshfs_uwaterloo ~/uwaterloo'
alias uw='sshuw'

# Specific linux machines
alias uw002='ssh_uwaterloo ubuntu1604-002'
alias uw004='ssh_uwaterloo ubuntu1604-004'
alias uw006='ssh_uwaterloo ubuntu1604-006'
alias uw008='ssh_uwaterloo ubuntu1604-008'

# 3B courses
alias cs343='cd ~/uwaterloo/cs343 && code .'
alias cs343-a6='cd ~/uwaterloo/cs343-a6 && code .'
alias cs454='cd ~/uwaterloo/cs454 && code .'
alias cs454-a3='cd ~/uwaterloo/cs454-a3 && code .'
alias cs456='cd ~/uwaterloo/cs456 && code .'
