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

#-------------
# (private) Utility functions...
#-------------

_readlinkf() {
    # This is a portable implementation of GNU's "readlink -f" in
    # bash/zsh, following symlinks recursively until they end in a
    # file, and will print the full dereferenced path of the specified
    # file even if the file isn't a symlink.
    #
    # Loop detection exists, but only as an abort after passing a
    # maximum length.

    local start_dir=$(pwd)
    local file=${1}
    cd $(dirname ${file})
    file=$(basename ${file})

    # Iterate down symlinks.  If we exceed a maximum number symlinks, assume that
    # we're looped and die horribly.
    local maxlinks=20
    local count=0
    local current_dir
    while [ -L "${file}" ] ; do
        file=$(readlink ${file})
        cd $(dirname ${file})
        file=$(basename ${file})
        ((count++))
        if (( count > maxlinks )) ; then
            current_dir=$(pwd -P)
            echo "CRITICAL FAILURE[4]: symlink loop detected on ${current_dir}/${file}"
            cd ${start_dir}
            return ${count}
        fi
    done
    current_dir=$(pwd -P)
    echo "${current_dir}/${file}"
    cd ${start_dir}
}

#-------------
# Shell welcome banner...
#-------------
show_hostname() {
    local font=${1:-"doom"}
    local namefile=${BASH_CACHE_DIR}/bash_banner_${BANNER_FONT}.txt
    local _hostname=$(hostname -s)
    #the file must be there and must have some content
    if [ -e "${namefile}" ] && (( $(\ls -l ${namefile} | awk '{print $5}') > 0 ))  && [ "$(sed -n '1p' ${namefile})" = "${_hostname}" ] ; then
        : /dev/null
    else
        #make a call to get ascii art via the ascii_grab.py program which contacts and scrapes...
        #http://www.network-science.de/ascii/ascii.php?TEXT=malcolm&x=32&y=13&FONT=doom&RICH=no&FORM=left&STRE=no&WIDT=80
        #for ascii art output
        #Just keeping this here as a reference, cause it was kinda cool... (used to execute the python loaded remotely)
        #local d="$(python <( curl -m 2 -s http://moya.6thcolumn.org/resources/bash/ascii_grab.py) ${font} ${_hostname})"
        local abs_path_bashrc=$(_readlinkf ${HOME}/.bashrc)
        local bash_resources_tld=${abs_path_bashrc%/*}
        [ ! -e "${bash_resources_tld}/tools/ascii_grab.py" ] && return 0
        echo "(font: ${font})"
        local d="$(python ${bash_resources_tld}/tools/ascii_grab.py ${font} ${_hostname})"
        [ -n "${d}" ] && printf "${_hostname}\n${d}\n" > ${namefile} && chmod 666 ${namefile}
    fi
    sed '1d' ${namefile} 2> /dev/null
}

show_welcome() {
    echo
    _os="$(uname -s)"
    echo "You are logged into a ${_os} Machine...(Version `uname -r`)"
    [ "${_os}" == "Darwin" ] && sw_vers
    echo " Host => `hostname -f`"
    [[ ! ${HOSTNAME_BANNER_OFF} ]] && show_hostname ${BANNER_FONT:-"doom"}
    echo
    echo " Hardware: `uname -m`...."
    echo " Using Emacs Bindings..."
    uptime
    echo
    fortune 2> /dev/null
    [ $? != 0 ] && echo "(psst... may want to install \"fortune\")"
    echo
}

#-------------
# Trashing Files...
#-------------
export TRASH=$HOME/.Trash

trash() {
  #${TRASH:?"You Should Set The Trash directory"}
  export ${TRASH:=$HOME/.Trash} >& /dev/null
  mkdir -p $TRASH >& /dev/null

  local file
  local all=0
  local good=0
  local bad=0
  
  for file in $@; do 
      mv $file $TRASH
      if [ $? == 0 ]; then 
          echo -n "."
          ((good++))
      else
          echo -n "X"
          ((bad++))
          
      fi
      ((all++))
  done
  echo
  if ((all == good)); then
      echo "all done"
  fi
  echo "Trashed ($good:$bad:$all):["$*"]"
}

show_trash() {
    local FOO=${TRASH:?"Must First Set Trash Directory!"}
    pushd $TRASH >& /dev/null
    du -sh *
    du -sh .
    popd >& /dev/null
}

empty_trash() {
    ${TRASH:?"Must First Set Trash Directory!"}
    pushd $TRASH >& /dev/null
    du -sh *
    du -sh .
    echo -n "Are you sure you want to empty the trash? [Yy/n] "
    read OK
    if [ "$OK" = y ] || [ "$OK" = Y ]; then
	/bin/rm -rf $TRASH/*
    else
	echo "Trash not emptied"
    fi
    popd >& /dev/null
}

ltrash() {
    mkdir -p ./.Trash
    mv "$*" ./.Trash
    echo "locally trashed:[$*]"
}

show_local_trash() {
    pushd ./.Trash >& /dev/null
    [ $? != 0 ] && echo "Sorry, You don't have a local trash!" && return 1
    du -sh * 2> /dev/null
    du -sh . 2> /dev/null
    popd >& /dev/null    
    return 0;
}

empty_local_trash() {
    ls ./.Trash >& /dev/null
    [ $? != 0 ] && "Sorry, You don't have a local trash money-grip!" && return 1
    show_local_trash
    local doit="n"
    read -p "Are you sure you want to empty trash in `pwd` [y/N] ? " doit
    doit=$(echo $doit | tr 'A-Z' 'a-z')
    if [ "$doit" = "y" ]; then
	#echo "rm -v -rf ./.Trash/*" 2> /dev/null
	rm -v -rf ./.Trash/* 2> /dev/null
    fi    
}

show_all_trash() {
    pushd ~/ >& /dev/null
    echo "Searching all trash files below `pwd`"
    for f in `find . -name '.Trash' `; do 
	pushd ${f%/*} >& /dev/null
	printf "\nFound Trash in ${f%/*}\n"
	[ $? != 0 ] && continue
	show_local_trash
	popd >& /dev/null
    done
    popd >& /dev/null
}

empty_all_trash() {
    pushd ~/ >& /dev/null
    echo "Emptying all trash files below `pwd`"
    local doit="n"
    for f in `find . -name '.Trash' `; do 
	pushd ${f%/*} >& /dev/null
	[ $? != 0 ] && continue
	empty_local_trash
	popd >& /dev/null
    done
    popd >& /dev/null
}

#-------------
# Stashing Files...
#-------------
export STASH=$HOME/.stash

stash() {
  #${STASH:?"You Should Set The Stash directory"}
  export ${STASH:=$HOME/.stash} >& /dev/null
  mkdir -p $STASH
  mv "$*" $STASH
  echo stashed:[$*]
}

show_stash() {
    FOO=${STASH:?"Must First Set Stash Directory!"}
    pushd $STASH >& /dev/null
    du -sh *
    du -sh .
    popd >& /dev/null
}

empty_stash() {
    ${STASH:?"Must First Set Stash Directory!"}
    pushd $STASH >& /dev/null
    du -sh *
    du -sh .
    echo -n "Are you sure you want to empty the stash? [Yy/n] "
    read OK
    if [ "$OK" = y ] || [ "$OK" = Y ]; then
	/bin/rm -rf $STASH/*
    else
	echo "Stash not emptied"
    fi
    popd >& /dev/null
}


#-------------
# Archiving Potentially Imporant Files...
#-------------
export ARCHIVE=${HOME}/.my_archive

archive() {
    export ${ARCHIVE:=${HOME}/.my_archive} >& /dev/null
    mkdir -p $ARCHIVE 
    mv "$*" $ARCHIVE
    echo archived:[$*]
}

show_archive() {
    FOO=${ARCHIVE:?"Must First Set Archive Directory!"}
    pushd $ARCHIVE >& /dev/null
    du -sh *
    du -sh .
    popd >& /dev/null
}

#---


find_in_code() {
    pushd ${PROJECT_HOME:=$(pwd)} >& /dev/null
    echo "find . -name \*.cc -o -name \*.h -o -name \*.cpp -o -name \*.hpp -o -name \*.py | xargs grep -i $*"
    find . -name \*.cc -o -name \*.h -o -name \*.cpp -o -name \*.hpp -o -name \*.py -o name \*.java | xargs grep -i $*
    popd >& /dev/null
}

#-------------
# Self updating...
#-------------

check_for_bash_resources_update() {
    local bash_file=${HOME:-~}/.bashrc
    [ ! -L "${bash_file}" ] && echo 'This file is not managed via bash_resources!!! (exiting)' && return 1
    echo "Inspecting Bash Resources..."
    bash_file=$(_readlinkf ${bash_file} | tail -n 1)
    local bash_resources_dir=${bash_file%/*}
    ((DEBUG)) && echo "Visiting [${bash_resources_dir}]..."
    pushd ${bash_resources_dir} >& /dev/null
    if [ $? != 0 ]; then
        echo "Sorry, could not enter \"${bash_resources_dir}\" :-(" && popd >& /dev/null
        return 2
    fi
    echo "Querying for updates..." && git fetch >& /dev/null
    [ $? != 0 ] && echo "ERROR: Could not perform fetch from repo!!! (hint: check network connectivity and try again)" && return 99

    local distance=$(source ${bash_resources_dir}/bash_git && __git_remote_dist)
    if [ $? != 0 ]; then
        echo "Sorry, problem getting distance metric... :-(" && popd >& /dev/null 
        return 0
    fi
    [ -z "${distance}" ] && echo "You are up to date :-)" && popd >& /dev/null && return 0

    local current_branch=$(git symbolic-ref HEAD | cut -d/ -f3)
    if [ $? != 0 ] || [[ -z "${current_branch}" ]]; then 
        echo "Sorry, you are not on a branch that can be updated" && popd >& /dev/null 
        return 3; 
    fi
    local remote_branch=$(git branch -vv | sed -n '/\* '${current_branch}'/p' | sed -n 's/[^[]*\[\([^]]*\)\].*/\1/p' | awk -F: '{print $1}')
    echo "Log:"
    echo "----------"
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative ${current_branch}..${remote_branch}
    echo "----------"
    echo
    local doit="n"
    read -e -p "Would you like to update now? [Y/n] " doit
    if [ "${doit}" = "N" ] || [ "${doit}" = "n" ] || [ "${doit}" = "no" ]; then
        popd >& /dev/null
        echo "(aborting)"
        return 0
    fi
    git pull 2> /dev/null && source ${bash_file} >& /dev/null && printf "\n[OK]\n"
    popd >& /dev/null
    return 0
}

#Ex: If I wanted to rename a bunch of files so that each file is renamed individually
# rename_file_set '*-s*.vmdk' Dnode Snode
#
#This can also be accomplished directly on the command line by doing:
# %> for f in `/bin/ls *-s*.vmdk`; do mv -v $f ${f//inpat/outpat}"; done
#
mvfileset() {

    exp=$1
    inpat=$2
    outpat=$3
    
    echo 
    echo "${exp} : ${inpat} -> ${outpat}"
    echo
    for infile in `ls ${exp}`; do
	outfile=$(eval "echo ${infile} | sed 's/${inpat}/${outpat}/'")
	mv -v ${infile} ${outfile}
    done
}

__on_mac=$(uname -a | grep -q Darwin && echo 1 || echo 0)
md5sum() {
    ((__on_mac)) && md5 $@ | sed -n 's/MD5 (\([^)]*\))[ ]*=[ ]*\(.*\)/\2 \1/p' || md5sum $@
}
