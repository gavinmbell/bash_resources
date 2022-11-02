#!/bin/bash
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
#   Prequequisites:
#          * brew (mac's package installer: https://brew.sh/)
#          * fortune
#               %> brew install fortune
#          * cowsay (cause it is mad funny when a cow says your fortune)
#               %> brew install cowsay
#          * bash-completion
#               %> brew install bash-completion@2
#          * hub (github's git wrapper)
#               %> brew install hub
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
DEBUG=0

mkdir -p ${BASH_CACHE_DIR:=${HOME}/.bash_cache}

#------
#bash-completion...
#------
if [ -f /usr/local/share/bash-completion/bash_completion ]; then
    #echo "using bash-completion v2 (installed with brew isnall bash-completion@2)"
     . /usr/local/share/bash-completion/bash_completion >& /dev/null
elif [ -f /usr/local/etc/bash_completion ]; then
    #echo "using bash-completion (installed with brew isnall bash-completion)"
    . /usr/local/etc/bash_completion >& /dev/null
else
    echo "NOTE: Please install bash-completion (%> brew install bash-completion)"
fi
#------

export PATH=.:~/bin:/usr/local/bin:/usr/local/sbin:/bin:/usr/bin:/usr/sbin:/sbin:/Library/TeX/texbin

export LANG="C"
export EDITOR='emacs'
export TERM="xterm-256color"
export CLICOLOR="true"
#-----
# http://osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/
#-----

# The color designators are as follows: (in foreground / background pairs)
#-------
# 1. directory
# 2. symbolic link
# 3. socket
# 4. pipe
# 5. executable
# 6. block special
# 7. character special
# 8. executable with setuid bit set
# 9. executable with setgid bit set
# 10. directory writable to others, with sticky bit
# 11. directory writable to others, without sticky bit
#-------
# a black
# b red
# c green
# d brown
# e blue
# f magenta
# g cyan
# h light grey
# A bold black, usually shows up as dark grey
# B bold red
# C bold green
# D bold brown, usually shows up as yellow
# E bold blue
# F bold magenta
# G bold cyan
# H bold light grey; looks like bright white
# x default foreground or background

#export LSCOLORS=dxgxcxdxbxcgcdabagacad
#export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
#export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
export LSCOLORS=ExGxBxDxBxEgEdxbxgxcxd

#-----
# http://linux-sxs.org/housekeeping/lscolors.html
#-----
export LS_COLORS="no=00:fi=00:di=33:ln=00;36:pi=40;33:so=00;35:bd=40;33;00:cd=40;33;00:or=40;31;00:ex=00;31:*.tar=00;*.class=00;22;*.jar=46;00:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.deb=00;31:*.rpm=00;31:*.jpg=00;35:*.png=00;35:*.gif=00;35:*.bmp=00;35:*.ppm=00;35:*.tga=00;35:*.xbm=00;35:*.xpm=00;35:*.tif=00;35:*.png=00;35:*.mpg=00;35:*.avi=00;35:*.fli=00;35:*.gl=00;35:*.dl=00;35:"
#-----

export TEMP="/tmp/`whoami`"
export TMP=${TEMP}
mkdir -p ${TEMP}

export PROJECT=${HOME}/projects
export DEVTOOLS=${HOME}/devtools

export CDPATH=.:..:$HOME/:$PROJECT/

export ESGF_SITE_ROOT=$PROJECT/esgf-site

#System-wide resources....
export JAVA_HOME=/usr/local/Cellar/openjdk/19/libexec/openjdk.jdk/Contents/Home
#export ANT_HOME=/usr/share/ant
#export M2_HOME=/usr/local/maven

#Account scope resources
[ -e $DEVTOOLS/tomcat ] && export CATALINA_HOME=$DEVTOOLS/tomcat
[ -e $CATALINA_HOME ] && export TOMCAT_HOME=$CATALINA_HOME
[ -e $DEVTOOLS/jwsdp/jaxb ] && export JAXB_HOME=$DEVTOOLS/jwsdp/jaxb
[ -e $DEVTOOLS/groovy ] && export GROOVY_HOME=$DEVTOOLS/groovy
[ -e $DEVTOOLS/jruby ] && export JRUBY_HOME=$DEVTOOLS/jruby
[ -e $DEVTOOLS/graalvm ] && export GRAALVM_HOME=$DEVTOOLS/graalvm/Contents/Home

export PATH=$PATH$( [ -e $GRAALVM_HOME/bin ] && echo ":$GRAALVM_HOME/bin" || echo "")\
$( [[ -n "${JAVA_HOME}" && -e $JAVA_HOME/bin ]] && echo ":$JAVA_HOME/bin" || echo "")\
$( [[ -n "${ANT_HOME}" && -e $ANT_HOME/bin ]] && echo ":$ANT_HOME/bin" || echo "")\
$( [[ -n "${M2_HOME}" && -e $M2_HOME/bin ]] && echo ":$M2_HOME/bin" || echo "")\
$( [[ -n "${GROOVY_HOME}" && -e $GROOVY_HOME/bin ]] && echo ":$GROOVY_HOME/bin" || echo "")\
$( [[ -n "${JRUBY_HOME}" && -e $JRUBY_HOME/bin ]] && echo ":$JRUBY_HOME/bin" || echo "")

#--------------------------
# GOlang PROGRAMMING LANGUAGE SETUP
#--------------------------
export GOPATH="${PROJECT}/go-projects"
export GOROOT="/usr/local/opt/go/libexec" # path via %> $(brew --prefix golang)
[[ -n "${GOPATH}" && -e ${GOPATH}/bin ]] && export PATH="$PATH:${GOROOT}/bin"
export GO111MODULE=on
#--------------------------

#--------------------------
# RUST PROGRAMMING LANGUAGE SETUP
#--------------------------
# Installation command:
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
if [ -s "${HOME}/.cargo/env" ]; then
    export RUSTUP_HOME="${HOME}/.rustup"
    export CARGO_HOME="${HOME}/.cargo"
    source "${CARGO_HOME}/env"
fi
#--------------------------

#--------------------------
# GCP Tools
#--------------------------
#export GOOGLE_APPLICATION_CREDENTIALS="${HOME}/Downloads/quixotic-spot-340713-334b949d4f41.json"
export GOOGLE_APPLICATION_CREDENTIALS="${HOME}/.cya/quixotic-spot-340713-3f86222ca475.json"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/cue/devtools/google-cloud-sdk/path.bash.inc' ]; then
    source '/Users/cue/devtools/google-cloud-sdk/path.bash.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/cue/devtools/google-cloud-sdk/completion.bash.inc' ]; then
    source '/Users/cue/devtools/google-cloud-sdk/completion.bash.inc'
fi
#--------------------------

complete -o default -o nospace -F _git_checkout gci
complete -o default -o nospace -F _git_checkout gco
complete -o default -o nospace -F _git_checkout gls

[ -e ~/.pythonrc ] && export PYTHONSTARTUP=~/.pythonrc
#-----------------------------

[ -d /usr/local/go/bin ] && ! grep -q /usr/local/go/bin <<<$PATH && export PATH="/usr/local/go/bin:$PATH" && echo -n "."

source ${HOME:-~}/.bash_aliases
source ${HOME:-~}/.bash_functions
source ${HOME:-~}/.bash_git

__local_bash_rc=${HOME:-~}/.bash_local
[ -e ${__local_bash_rc} ] && source ${__local_bash_rc}

#----------------------------
# User Banner Preferences ;-)
#----------------------------
[[ -z "${banner_fonts}" ]] && declare -r banner_fonts=(doom banner cybermedium digital doh dotmatrix epic fuzzy gothic hollywood isometric1 larry3d lean letters puffy pebbles script serifcap shadow slant smisome1 smslant smkeyboard speed standard starwars stop straight thin tinker-toy) >& /dev/null
BANNER_FONT=${banner_fonts[$((RANDOM % ${#banner_fonts[@]}))]} #var used in bash_functions in "show_welcome" function
#-----------------------------
# PROMPT
#-----------------------------
# (some handy color constants)
declare -r _RED="\[\033[01;31m\]" >& /dev/null   #bold
declare -r _GREEN="\[\033[01;32m\]" >& /dev/null #bold
declare -r _BLUE="\[\033[01;34m\]" >& /dev/null  #bold
declare -r _GOLD="\[\033[01;33m\]" >& /dev/null  #bold
declare -r _WHITE="\[\033[00;37m\]" >& /dev/null
declare -r _NOCOLOR="\[\033[00;00m\]" >& /dev/null
declare -r _CLOSE_COLOR="\[\033[00m\]" >& /dev/null

# (vars to set color of each prompt portion)
# PROMPT_ADDRESS_COLOR=
# PROMPT_DIR_COLOR=
# PROMPT_GIT_BRANCH_COLOR=
# PROMPT_COMMAND_HIST_INDEX_COLOR=

# (vars for modifying behavior of git portion of prompt)
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUPSTREAM="auto git verbose"
GIT_PS1_STATESEPARATOR=""
GIT_PS1_SHOWCOLORHINTS=1
source ${HOME:-~}/.bash_git_prompt

case "$TERM" in
    xterm | xterm-color | xterm-256color)
        ## Charles Doutriaux 2013-02-06
        ## Commenting out gives weird character on centos and terminal length issues
        ##PS1='${debian_chroot:+($debian_chroot)}\[\033[00;33m\]\u@\h\[\033[00m\]:[\033[00;31m\]\W\[\033[00m\]]$(__git_ps1 ":[\033[00;32m\]%s$(__git_prompt_info)\033[00m\]]"):[\!]> '
        if [ -z "${_PS1}" ]; then
          PS1=\
${PROMPT_ADDRESS_COLOR:-${_GOLD}}'\u@\h'${_CLOSE_COLOR}\
${_NOCOLOR}':['${_CLOSE_COLOR}\
${PROMPT_DIR_COLOR:-${_RED}}'\W'${_CLOSE_COLOR}\
${_NOCOLOR}']:'${_CLOSE_COLOR}\
${PROMPT_GIT_BRANCH_COLOR:-${_GREEN}}'$(__git_ps1 "[%s]\[\033[00m\]:")'${_CLOSE_COLOR}\
${_NOCOLOR}'['${_CLOSE_COLOR}\
${PROMPT_COMMAND_HIST_INDEX_COLOR:-${_NOCOLOR}}'\!'${_CLOSE_COLOR}\
${_NOCOLOR}']> '${_CLOSE_COLOR}
          _PS1=${PS1}
        fi
       PROMPT_COMMAND='[ -n "${TERMCAP}" ] && grep -q "eterm-color" <<< "${TERMCAP}" && echo "$pwd" || echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"; history -a'
        ;;
    *)
        if [ -z "${_PS1}" ]; then
            PS1='\u@\h:[\W]:[\!]> '
            _PS1=${PS1}
        fi
        ;;
esac
#-----------------------------
show_welcome

export NVM_DIR="/Users/cue/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

[ -s "/Users/cue/.web3j/source.sh" ] && source "/Users/cue/.web3j/source.sh"
