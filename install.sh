#!/usr/bin/env bash

cd $(dirname ${BASH_SOURCE})/
OS="null"
KERNEL="null"
ARCH="null"
DEFSFILE="defs.tml"

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
	find_os
	find_arch
	find_exe_suffix
	BINNAME=homemaker_${KERNEL}_${ARCH}${SUFFIX}
	ARGS=()
	if [ $DRY -eq 1 ]; then
		ARGS+=("-nocmds")
		ARGS+=("-nolinks")
		ARGS+=("-notemplates")
	fi
	if [ $VERBOSE -eq 1 ]; then
		ARGS+=("-verbose")
	fi
	for i in "$@"; do
		HM_OVERLAY=${OVERLAY} homemaker/$BINNAME ${ARGS[@]} -variant $OS -task package_$i $DEFSFILE .
		HM_OVERLAY=${OVERLAY} homemaker/$BINNAME ${ARGS[@]} -variant $OVERLAY -task setup_$i $DEFSFILE .
	done
}

queue_install() {
	PACKAGES+=($1)
}

list_packages() {
	awk -F. '/^\[tasks\.package/ { print substr($2, 9, length($2)-9) }' $DEFSFILE
}

list_overlays() {
	awk -F_ '/^\[tasks\.setup_.+__.+]/ { print substr($4, 1, length($4)-1) }' $DEFSFILE|sort|uniq
}

system_report() {
	find_os
	find_arch
	find_exe_suffix
	cat <<- EOM
	  Your OS: $OS
	  Your kernel: $KERNEL
	  Your architecture: $ARCH
	  Your executable suffix: $SUFFIX
	  This means we want to use: homemaker_${KERNEL}_${ARCH}${SUFFIX}
	EOM
}

verbose_log() {
	if [ $VERBOSE -eq 1 ]; then
		echo $@
	fi
}

show_usage() {
	cat <<HELP
Usage: $0 <option>

One of:
	-d	Dry run
	-h	Show this message
	-i	Install packages. Can be used more than once for multiple packages
	-l	List packages
	-L	List overlays
	-o	Set an overlay for the configs we lay down (default: $OVERLAY)
	-r	Report OS/architecture
	-s	Setup dotfiles
	-v	Verbose output
HELP
}

# Plan
DRY=0
VERBOSE=0
PACKAGES=()
OVERLAY="sno"
while getopts ":dhi:Llo:rsv" opts; do
	case $opts in
		d)
			DRY=1
			;;
		h)
			show_usage
			exit 0
			;;
		i)
			queue_install $OPTARG
			;;
		l)
			list_packages
			exit 0
			;;
		L)
			list_overlays
			exit 0
			;;
		o)
			OVERLAY=$OPTARG
			;;
		r)
			system_report
			exit 0
			;;
		s)
			# Setup dotfiles w/o install
			echo "Not yet implemented on its own"
			exit 0
			;;
		v)
			VERBOSE=1
			;;
		:)
			echo "Error: -$OPTARG requires an argument"
			show_usage
			exit 1
			;;
		*)
			echo "Error: Unknown option -$OPTARG"
			show_usage
			exit 1
			;;
	esac
done

# Do it
if [ ${#PACKAGES[@]} -eq 0 ]; then
	echo "Nothing to do. Exiting..."
	exit 0
fi

if [ $DRY -eq 1 ]; then
	echo "Doing dry run..."
fi

verbose_log "Set overlay to $OVERLAY"

install_tasks ${PACKAGES[@]}
