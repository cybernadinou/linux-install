#!/bin/bash

function isPacakageInstalled {
    package=$1
    isInstalled=$(dpkg --get-selections | grep --regexp=^$package-4.3.*install$)
    if [ isInstalled ]; then
        return true;
    fi
    return false;
}

function install_pacakge  {
    package=$1
    # Gonna install the package check if all is ok
    if apt-get -qq install $package; then
        echo "Successfully installed $pkg"
    else
        echo "Error installing $pkg"
    fi
}

function is_dir {
    if [ -d "$1" ]; then
        return 1
    else
        return 0
    fi
}

function isRoot {
    # 0 = root by default
    if [ $EUID -ne "0" ]; then
       echo "This script must be run as root"
       return 1
    fi
    return 0
}


function insert_into_json_file {
    echo
}

function get_ip_public {
    local ip
    ip=$(wget -qO- ifconfig.me/ip)
    return $ip
}

function update_upgrade {
    ( apt-get update && apt-get upgrade -y ) || echo "Sorry but something wrong happened. Please check your network configuration and try to upgrade your OS manually. Thx" && exit;
}

function ping_access {
  # -q quiet
  # -c how many ping to perform
  ping -q -c5 $1 > /dev/null
  rst=$?
  if [ $rst != 0 ]; then
    echo "$1 is unreachable. Please check your firewall or your network access and think about your country (China )?" >> $HOME/results
  fi
  return $rst;
}

function default_case_while {
    echo "Sorry, your choice is not available'"
    read -p "Please try again : [Enter key]"
    clear
}