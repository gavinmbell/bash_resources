#*****************************************************************
# Copyright (c) 2013 The 6Th Column Project
# All rights reserved.
#*****************************************************************
#
#  Organization: A Couple of Guys That Need A Life
#   Directorate: Computation
#    Department: Computing Applications and Research
#       Program: Tom Foolery
#       Project: BASH-FOO
# First Authors: Gavin M. Bell (gavin@llnl.gov) & 
#                Charles Doutriaux (doutriaux1@llnl.gov)
#
#   Description:
#   A clean and easy way to setup your bash environment that is hassle free.
#   We use lots of different machines... it makes it less painful
#
#*****************************************************************

#****************
#General
#****************

alias backup="rsync --archive --verbose --progress --stats --compress --rsh=/usr/bin/ssh --recursive --times --perms --links --update"
alias src='source ~/.bashrc'
alias beroot='sudo -s'
alias c=clear
alias dirs='dirs -v'
alias vt='set term=vt100'
alias NODISP='unsetenv DISPLAY'
alias ..='cd ..'
alias ...='cd ../..'
alias .='echo $cwd'
alias ll='ls -l'
alias dir=ll
alias lst='ls -FAlt | less'
alias lr='ls -rt'
alias lrt='ls -lrth'
alias lrtl='ls -lrth | less'
alias lart='ls -larth'
alias lartl='ls -larth | less'
alias la='ls -FA'
alias lf='ls -Fg'
alias lc='ls -Cg'
alias a=alias
alias h=history

#alias hist=history same as h

alias pd=pushd
alias push=pushd
alias pop=popd
alias md=mkdir
alias rd=rmdir
alias cls=clear

alias screen='screen -R'
alias screen_here='screen -d'
alias screen_HERE='screen -D'
alias pss='ps auxw | grep cue'
alias whom='who | sort | more'
alias wsm='w | sort | more '
alias emacs='emacs -bg black -fg wheat '
alias e='/usr/bin/emacs -nw'
alias close='eject -t'

#alias xterm='xterm -sb -sl 5000 -bg black -fg wheat &'
alias xterm='xterm -sb -sl 5000 -bg grey5 -fg wheat &'

alias findsrc="find -name '*.c' -o -name '*.h' -o -name '*.cc' -o -name '*.hpp' -o -name '*.cpp' -o -name '*.py'"

#alias grep='grep --color-auto'

#### GIT ####
alias gstat='git status'
alias gci='git commit'
alias gco='git checkout'
alias gls='git branch'
alias gitweb='git instaweb -d webrick'
alias gstat='git status'
ghelp() { 
    ssh latimer.llnl.gov git help $@ | less 
}

# Emacs under X11
#alias emacsserver="\emacs --daemon"
#alias emacs="emacsclient -c"

# Emacs under MacOS
alias emacsserver="/Applications/Emacs.app/Contents/MacOS/Emacs --daemon"
alias emacs="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -c "
