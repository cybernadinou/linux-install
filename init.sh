#!/bin/bash

# Init file :
# 1 Client Side : gonna launch an other menu script for Linux Mint
# 2 server Side : gonna launch an other menu script for Debian

#Globale varibale for
source ./functions/global_variable.sh
source  ./functions/global_function.sh

function init {
    local rm -opt./in
    while :
    do
        #clear
        echo "   M A I N - M E N U"
        echo "1. Client Side"
        echo "2. Server Side"
        echo "3. Exit"
        read -p "Please enter option [1 - 3] " opt
        case $opt in
            1)  ./client/client_side.sh;
                break;;
            2)  ./server/init.sh;
                break;;
            3)  echo "Bye $USER";
                exit 1;;
            *)  echo $default_value_while ;
        esac
    done
}

isRoot
init
