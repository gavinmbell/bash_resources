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

cterm() {
    /usr/X11R6/bin/xterm -sb -sl 10000 -bg grey8 -fg $* &
}

homefiles() {

    ls -l /etc/hosts
    sudo rm /etc/hosts
    sudo ln -s /etc/hosts.home /etc/hosts
    ls -l /etc/hosts

    #ls -l /etc/fstab
    #sudo rm /etc/fstab
    #sudo ln -s /etc/fstab.home /etc/fstab
    #ls -l /etc/fstab
}

workfiles() {
    ls -l /etc/hosts
    sudo rm /etc/hosts
    sudo ln -s /etc/hosts.cuill /etc/hosts
    ls -l /etc/hosts

    #ls -l /etc/fstab
    #sudo rm /etc/fstab
    #sudo ln -s /etc/fstab.cuill /etc/fstab
    #ls -l /etc/fstab
}

dopostlist() {
    a=$(readlink `which postlist`)
    b=${a%/*}
    pushd ${b} >& /dev/null
    ./postlist
    popd >& /dev/null
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

#do a pull on all esgf projects
esgf_git_pull_all() {
    pushd ${1:-${HOME}/projects}
    for proj in $(ls -d esg*); do 
        echo "-----------"
        git status
        pushd $proj
        git status
        git pull
        popd >& /dev/null
        echo "-----------"
        echo
    done
    popd >& /dev/null
}

[ -e ${PROJECT}/esg-dist/utils/misc/util_functions ] && source ${PROJECT}/esg-dist/utils/misc/util_functions

#ca_list() {
#    pushd ${HOME}/projects/esg-certs/esg_trusted_certificates >& /dev/null
#    for file in `/bin/ls -rt | grep -v signing_policy`; do openssl x509 -in $file -noout -issuer -issuer_hash; done | grep "$1"
#    popd >& /dev/null
#}
#esg_pull_projects() {
#    pushd $PROJECT >& /dev/null
#    for repo in `ls -d esg*-* | grep -v site | xargs`; do
#        pushd "$repo" >& /dev/null
#        echo "pulling $repo"
#        git pull 2> /dev/null
#        popd >& /dev/null
#    done
#    popd >& /dev/null
#}
#
#esg_pull_sites() {
#    pushd $PROJECT >& /dev/null
#    ls -d * | egrep '^esg[f]??-.*site$' | xargs
#    for repo in `ls -d esg*-* | grep site | xargs`; do
#        pushd "$repo" >& /dev/null
#        echo "pulling $repo"
#        git pull
#        popd >& /dev/null
#    done
#    popd >& /dev/null
#}
