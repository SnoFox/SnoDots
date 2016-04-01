#!/usr/bin/env bash

cd $(dirname ${BASH_SOURCE})/
OS="null"
KERNEL="null"
ARCH="null"

find_linux_distro() {
	[ -e /etc/os-release ] && relfile="/etc/os-release" || relfile="/usr/lib/os-release"
	if [ -n "$relfile" ]; then
		OS=$( cat /etc/os-release|grep -G '^ID='|cut -d= -f2|tr -d \" )
	else
		OS="unknown-linux"
	fi
}

find_os() {
	case $( uname -s | tr [:upper:] [:lower:] ) in
		cygwin*)
			KERNEL="windows"
			OS="cygwin"
			;;
		linux)
			KERNEL="linux"
			find_linux_distro
			;;
		darwin)
			KERNEL="darwin"
			OS="macosx"
			;;
		sunos)
			KERNEL="sunos"
			OS="sunos"
			;;
		*)
			OS="unknown"
			;;
	esac
}

find_arch() {
	case $(uname -m) in
		x86_64)
			ARCH="amd64"
			;;
		i86pc)
			ARCH="amd64"
			;;
		armv5tel)
			ARCH="arm"
			;;
		*)
			ARCH="unknown"
			;;
	esac
}

find_exe_suffix() {
	if [ $KERNEL == "windows" ]; then
		SUFFIX=".exe"
	else
		SUFFIX=""
	fi
}

install_tasks() {
	if [ $# -eq 0 ]; then
		echo 'No tasks requested; installing "base"'
		set -- base $@
	fi
	find_os
	find_arch
	find_exe_suffix
	BINNAME=homemaker_${KERNEL}_${ARCH}${SUFFIX}
	for i in "$@"; do
		homemaker/$BINNAME -task $i -variant $OS base.tml .
	done
}


show_usage() {
	cat <<HELP
Usage: $0 <option>

One of:
	-h		Show this message
	-i		Install packages
	-s		Setup dotfiles
HELP
}

while getopts "his" opts; do
	case $opts in
		h)
			show_usage
			exit 0
			;;
		i)
			shift
			install_tasks $@
			exit 0
			;;
		s)
			echo "Not yet implemented"
			exit 0
			;;
		*)
			echo "Unknown option: $OPTARG"
			show_usage
			exit 1
			;;
	esac
done
