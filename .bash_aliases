#!/bin/bash
#*****************************************************************
# Copyright (c) 2009  Larence Livermore National Security (LLNS)
# All rights reserved.
#*****************************************************************
#
#  Organization: Lawrence Livermore National Lab (LLNL)
#   Directorate: Computation
#    Department: Computing Applications and Research
#      Division: S&T Global Security
#        Matrix: Atmospheric, Earth and Energy Division
#       Program: PCMDI
#       Project: Earth Systems Grid
#  First Author: Gavin M. Bell (gavin@llnl.gov)
#
#   Description:
#
#*****************************************************************


#****************
#Java Related...
#****************
alias axis_cp="source $HOME/bin/axis_classpath"
alias kawa="java kawa.repl"
alias beanshell="java bsh.Interpreter"
alias bsh="java bsh.Interpreter"
#alias javac="javac -d ${CLASS_ROOT}"
alias compile="javac -nowarn -d ${CLASS_ROOT}"
alias jikes="jikes -nowarn -d ${CLASS_ROOT}"
alias jruby-console="java -jar $JAR_PATH/jruby-console.jar"


#****************
#maintenance aliases
#****************
alias full_backup="sudo rsync -xrlptgoEv --progress --delete / /Volumes/Malcolm_HD_Backup"

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
alias hist=history
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

alias mysql_dev="mysql -hlocalhost -udevuser -pdevpassword"
alias mysql_root="mysql -hlocalhost -uroot -pshaalein"

#-----------------------
#	Machine/Host Aliases
#-----------------------

#### Lawrence Livermore National Labs (LLNL) ####
alias bio-e="ssh bell51@bio-e.llnl.gov"
alias bkc-cvs="ssh bell51@bkc-cvs.llnl.gov"
alias xber1-dev="ssh bell51@xber1-dev.llnl.gov"
alias talon="ssh cue@talon.llnl.gov"
alias anchor="ssh cue@anchor.llnl.gov"
alias lost="ssh cue@lost.llnl.gov"
alias calaveras="ssh cue@calaveras.llnl.gov"

#----
alias pcmdi3="ssh bell51@pcmdi3.llnl.gov"
alias rainbow="ssh bell51@rainbow.llnl.gov"
alias climate="ssh bell51@climate.llnl.gov"
alias gdo="ssh bell51@gdo2.ucllnl.org"
alias narccap="ssh bell51@narccap.llnl.gov"
alias esg-repo="ssh esg-user@esg-repo.llnl.gov"


alias malcolm="ssh bell51@malcolm.llnl.gov" #Mac Pro box
alias martin="ssh bell51@martin.llnl.gov"   #VM Ubuntu box
alias assata="ssh bell51@assata.llnl.gov"   #VM Windows box
alias latimer="ssh bell51@latimer.llnl.gov" #Linux box

# --- My Mini Cluster ---
alias woods="ssh bell51@woods.llnl.gov"
alias west="ssh bell51@west.llnl.gov"
alias williams="ssh bell51@williams.llnl.gov"
alias miles="ssh bell51@miles.llnl.gov"

#alias mccoy="ssh bell51@mccoy.llnl.gov"
#alias morgan="ssh bell51@morgan.llnl.gov"

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

