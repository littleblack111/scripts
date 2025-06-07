#!/bin/bash
#===============================================================================
#
#          FILE: edit.sh
#
#         USAGE: ./edit.sh
#
#   DESCRIPTION: Simple script that runs editor as sudo if necessary.
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Chevalier de Balibari (chevalierdebalibari@keemail.me), 
#  ORGANIZATION: ---
#       CREATED: 04/11/2019 09:22:29 AM
#      REVISION:  ---
#===============================================================================

#set default editor
if [ -z $VIM_PATH ]; then
	VIM_PATH=/usr/bin/nvim
fi

#check if an argument is provided
if [ -z $1 ]
then
	#open editor only,  no argument is provided
	$VIM_PATH
else
	#test if file exists
	if [ ! -f $1 ]
	then
		#file don't exist, destination folder permissions apply
		FILE_PATH=$1
		DESTINATION_FOLDER_PATH=${FILE_PATH%/*}
		#test if path or filename is provided
		if [ $FILE_PATH == $DESTINATION_FOLDER_PATH ]
		then
			#destination folder path is current working directory
			DESTINATION_FOLDER_PATH=$PWD
		fi
		#check if destination folder is writable by user
		if [ -w $DESTINATION_FOLDER_PATH ]
		then
			#open editor as ordinary user
			$VIM_PATH $FILE_PATH
		else
			#open editor as sudo user
			sudo $VIM_PATH $FILE_PATH
		fi
	#file exists, file permissions apply
	else
		if [ -w $1 ]
		then
			#open editor as ordinary user
			$VIM_PATH $1
		else
			#open editor as sudo user
			sudo $VIM_PATH $1
		fi
	fi
fi

