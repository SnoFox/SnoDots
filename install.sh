#!/usr/bin/env bash

########
# Docs #
########

# install.sh
# Exit codes
# 1 - usage error

############
# Modpacks #
############

typeset -A packs
packs[lite]="zsh bash commonsh vim top git lessfilter screen"
packs[heavy]="zsh-syntax-highlighting"
packs[desktop]="conky"
packs[windows]="minitty"
packs[okta-zsh]=""

########
# Code #
########

loglevel=1

function log() {
	if [ $loglevel -ge $1 ]; then
		thisloglevel=$1
		shift
		case $thisloglevel in
			0)
				logstr=""
				;;
			1)
				logstr="WARNING: "
				;;
			2)
				logstr="VERBOSE: "
				;;
			3)
				logstr="DEBUG: "
				;;
			*)
				logstr="LOG: "
				;;
		esac
		echo "${logstr}$@"
	fi
}

function command_append() {
	# $1 - source file; $2 - dest to append
	log 2 "Appending data to $2"
	cat $1 >> $2
}

function command_place() {
	# $1 - source; $2 - destination
	log 2 "Placing $1 in $2..."
	cp -a $1 $2
}

function command_replace() {
	# $1 - source; $2 - destination
	log 2 "Replacing $1 with $2..."
}

function command_package() {
	# $1 package
	# XXX logic to find the package
	test 1 # Noop
}
function command_depends() {
	# $1 - dependant mod
	run_mod $1
}

function show_usage() {
	cat <<SHOWHELP
Usage: $0 [OPTIONS] [ARGS]

Available options:
	-h		show this message
	-p		specify a mod pack to install
	-m		specify a single mod to install
	-v		verbose output
	-q		supress warnings
SHOWHELP
}

function run_modpack() {
	if [ -z ${packs[$1]} ]; then
		echo "Skipping $1 pack -- nonexistent or empty"
	else
		for mod in ${packs[$1]}; do
			run_mod $mod
		done
	fi
}

function run_mod() {
	echo "Running mod $1 ..."
	# Actions: append, place, replace
	IFS=$'\n'
	for line in $(cat $1/props.txt); do
		cmd=$( echo $line | cut -f1 -d= | tr [:upper:] [:lower:] )
		args=$( echo $line | cut -f2- -d= )
		echo "cmd: $cmd; args: $args"
		case $cmd in
			\#*)
				;;
			append)
				command_append $args
				;;
			place)
				command_place $args
				;;
			replace)
				command_replace $args
				;;
			package)
				command_package $args
			*)
				echo "Unknown command $cmd in mod $1"
				;;
		esac
	done
}

while getopts ":p:m:hqv" opts; do
	case $opts in
		h)
			show_usage
			exit 0
			;;
		p)
			run_modpack $OPTARG
			;;
		m)
			run_mod $OPTARG
			;;
		v)
			loglevel=$( expr $loglevel + 1 )
			log 3 Set log level to $loglevel
			;;
		q)
			loglevel=0
			log 3 Set log level to $loglevel
			;;
		*)
			echo "Unknown option: $OPTARG"
			show_usage
			exit 1
			;;
	esac
done
