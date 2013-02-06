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

[ -z "$PS1" ] && return

shopt -s extglob
shopt -s dotglob
shopt -s cdspell
shopt -s histappend
shopt -s checkwinsize

set -o emacs
#set -o ignoreeof
export IGNOREEOF=1

set show-all-if-ambiguous on                                                    
set visible-stats on 

export LC_CTYPE="en_US.UTF-8"
export HISTCONTROL=ignoredups
export HISTSIZE=1000000
export HISTFILESIZE=1000000
export TMOUT=0

export BASH_COMPLETION=${HOME:-~}/.bash_completion >& /dev/null
export BASH_COMPLETION_DIR=${HOME:-~}/.bash_completion.d >& /dev/null
source $BASH_COMPLETION >& /dev/null
source $BASH_COMPLETION_DIR/* >& /dev/null
export PATH=.:~/bin:/usr/local/bin:/usr/local/sbin:/usr/local/git/bin:/sw/bin:/bin:/usr/bin:/usr/sbin:/sbin:/usr/X11R6/bin:/usr/texbin

export LANG="C"
export EDITOR='emacs'
export TERM="xterm-color"
export CLICOLOR="true"
#-----
# http://osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/
#-----
export LSCOLORS=dxgxcxdxbxcgcdabagacad

#-----
# http://linux-sxs.org/housekeeping/lscolors.html
#-----
export LS_COLORS="no=00:fi=00:di=33:ln=00;36:pi=40;33:so=00;35:bd=40;33;00:cd=40;33;00:or=40;31;00:ex=00;31:*.tar=00;*.class=00;22;*.jar=46;00:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.deb=00;31:*.rpm=00;31:*.jpg=00;35:*.png=00;35:*.gif=00;35:*.bmp=00;35:*.ppm=00;35:*.tga=00;35:*.xbm=00;35:*.xpm=00;35:*.tif=00;35:*.png=00;35:*.mpg=00;35:*.avi=00;35:*.fli=00;35:*.gl=00;35:*.dl=00;35:"
#-----

export GREP_OPTIONS='--color=auto' 
export GREP_COLOR='01;36;*'

export TEMP="/tmp/`whoami`"
export TMP=${TEMP}
mkdir -p ${TEMP}

export PROJECT=${HOME}/projects
export DEVTOOLS=${HOME}/devtools

export CDPATH=.:..:$HOME/:$PROJECT/

source ~/.git_bashrc
#-------------------------------------------
RED="\[\033[00;31m\]"
GREEN="\[\033[00;32m\]"
BLUE="\[\033[00;34m\]"
GOLD="\[\033[00;33m\]"
NOCOLOR="\[\033[00;00m\]"

case "$TERM" in
    xterm | xterm-color) 
        ## Charles Doutriaux 2013-02-06
	## Commenting out gives weird character on centos and terminal length issues
	##PS1='${debian_chroot:+($debian_chroot)}\[\033[00;33m\]\u@\h\[\033[00m\]:[\033[00;31m\]\W\[\033[00m\]]$(__git_ps1 ":[\033[00;32m\]%s$(__git_prompt_info)\033[00m\]]"):[\!]> '
        PS1='${debian_chroot:+($debian_chroot)}'${BLUE}'\u@\h'${NOCOLOR}':['${RED}'\W'${NOCOLOR}']:'${GREEN}'$(__git_ps1 "[%s$(__git_prompt_info)]")'${NOCOLOR}'['${GOLD}'\!'${NOCOLOR}']>'

	PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007";history -a'
	;;
    *)
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:[\W]:[\!]> '
	;;
esac
#-----------------------------

export ESGF_SITE_ROOT=$PROJECT/esgf-site

#System-wide resources....
export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home
export ANT_HOME=/usr/share/ant
export M2_HOME=/usr/local/maven

#Account scope resources
export CATALINA_HOME=$DEVTOOLS/tomcat
export TOMCAT_HOME=$CATALINA_HOME
export JAXB_HOME=$DEVTOOLS/jwsdp/jaxb
export GROOVY_HOME=$DEVTOOLS/groovy
export JRUBY_HOME=$DEVTOOLS/jruby

export PATH=$PATH$( [ -e $JAVA_HOME/bin ] && echo ":$JAVA_HOME/bin" || echo "")\
$( [ -e $JAVA_HOME/bin ] && echo ":$JAVA_HOME/bin" || echo "")\
$( [ -e $ANT_HOME/bin ] && echo ":$ANT_HOME/bin" || echo "")\
$( [ -e $M2_HOME/bin ] && echo ":$M2_HOME/bin" || echo "")\
$( [ -e $JRUBY_HOME/bin ] && echo ":$JRUBY_HOME/bin" || echo "")

export CLASS_ROOT=$HOME/classes
export JAR_PATH=$HOME/classes/jars
export CLASSPATH=.
if [ -e "${CLASS_ROOT}" ]; then
    export CLASSPATH=.:$CLASS_ROOT
fi
if [ -e "${JAR_PATH}" ]; then
    export CLASSPATH=$CLASSPATH:$(find $JAR_PATH | xargs | perl -pe 's/ /:/g')
fi

#-----------------------------
source ~/.bash_aliases
source ~/.bash_functions
#-----------------------------
complete -o default -o nospace -F _git_checkout gci
complete -o default -o nospace -F _git_checkout gco
complete -o default -o nospace -F _git_checkout gls

export PYTHONSTARTUP=~/.pythonrc

BANNER_FONT="doom"
source $HOME/.bash_local >& /dev/null
show_welcome
