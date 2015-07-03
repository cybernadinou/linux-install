#!/bin/bash

# Includes file / functions
. ../functions/global_function.sh


# Note for myself :
#  use private variable not GLOBALE (It's EVIL !! ^^ ) 
#
#  Cinnamon settings : 
#	Desktop shortcut to delete +
#	Adding shortcuts taskbar : Skype /Hipchat / Transmission / 
#FileZilla / Jdownloader / VirtualBOX / MySQLWorkbench / Android Studio / 
#PhPStorm / Screenshot
#
#  Use CONSTANTE String (FILE_IPTABLES + DDL_PHPSTORM + VERSION_PHPSTORM + IPTABLESLOAD )
#  Imrpovement : create menu and submenu (more clean that all in one)
#     Ex : Menu : client and server
#	  Client : default config / set defaults apps prefered / rsync
# 	  Server : Samba (3 - 4 ) / uTorrent / OpenVPN / etc

###
# Functions
###



# Install all packages that i need for Linux Mint
packages="android-studio jdownloader-installer git git-all gcc make iptables vokoscreen cheese filezilla skype  mysql-workbench python-software-properties python g++ aircrack-ng reaver pdftk virtualbox-4.3 imagemagick gparted"

# Try Catch Like
# Check apt-get update and upgrade done 
( apt-get update && apt-get upgrade -y ) || echo "Sorry but something wrong happened. Please check your network configuration and try to upgrade your OS manually. Thx" && exit;

apt-add-repository ppa:paolorotolo/android-studio
add-apt-repository ppa:jd-team/jdownloader

if ping_access hipchat.com; then
  echo "deb http://downloads.hipchat.com/linux/apt stable main" > /etc/apt/sources.list.d/atlassian-hipchat.list
  wget -O - https://www.hipchat.com/keys/hipchat-linux.key | apt-key add -
  packages="$packages hipchat"
fi 

if ping_access dropbox.com; then
  echo "deb http://linux.dropbox.com/debian squeeze main" >> /etc/apt/sources.list.d/dropbox-linux.list
  packages="$packages dropbox"
fi

apt-get update && apt-get install $packages -y

# 5/30/2015 => Check if any updates (try catch)
wget http://download-cf.jetbrains.com/webide/PhpStorm-8.0.3.tar.gz
mv PhpStorm-8.0.3.tar.gz /opt
cd /opt
tar -zxvf PhpStorm-8.0.3.tar.gz
./PhpStorm-8.0.3/bin/phpstorm.sh

######################################################
#           REGLES IPTABLES                 #
######################################################
 
# Reset rules
iptables -t filter -F
iptables -t filter -X
  
# Deny all
iptables -t filter -P INPUT DROP
iptables -t filter -P FORWARD DROP
iptables -t filter -P OUTPUT DROP
  
# Allow established and localhost connection
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# Loopback
iptables -t filter -A INPUT -i lo -j ACCEPT
iptables -t filter -A OUTPUT -o lo -j ACCEPT
  
# ICMP (Ping)
iptables -t filter -A INPUT -p icmp -j ACCEPT
iptables -t filter -A OUTPUT -p icmp -j ACCEPT
 
# DNS
iptables -t filter -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -t filter -A INPUT -p udp --dport 53 -j ACCEPT
 
# HTTP
iptables -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 80 -j ACCEPT

# HTTPS 
iptables -t filter -A OUTPUT -p tcp --dport 443 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 443 -j ACCEPT

# DDOS
iptables -A FORWARD -p tcp --syn -m limit --limit 1/second -j ACCEPT
iptables -A FORWARD -p udp -m limit --limit 1/second -j ACCEPT
iptables -A FORWARD -p icmp --icmp-type echo-request -m limit --limit 1/second -j ACCEPT

# Limit nmap (scan port)
iptables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j ACCEPT

iptables-save > /etc/iptables_rules

######
# Setting IPTABLES TO REBOOT
######
if [ -d /etc/network/if-pre-up.d ]; then
  echo "#!/bin/sh
iptables-restore < /etc/iptables_rules
exit 0" > /etc/network/if-pre-up.d/iptablesload
  chmod +x /etc/network/if-pre-up.d/iptablesload
fi

####
# Preferred apps
####

# Defaults Apps => IMPROVING THIS PART : DRY
if [ ! -d ~/.local/share/applications ]; then
	mkdir ~/.local/share/applications
fi

echo "[Default Applications]"  > ~/.local/share/applications/mimeapps.list

cat /usr/share/applications/banshee.desktop | sed 's/;/=banshee.desktop\n/g' | grep audio >> ~/.local/share/applications/mimeapps.list

cat /usr/share/applications/vlc.desktop | sed 's/[;=]/=vlc.desktop\n/g' | grep video >> ~/.local/share/applications/mimeapps.list
echo "
[Added Associations]"  >> ~/.local/share/applications/mimeapps.list

cat /usr/share/applications/banshee.desktop | sed 's/;/=banshee.desktop\n/g' | grep audio >> ~/.local/share/applications/mimeapps.list

cat /usr/share/applications/vlc.desktop | sed 's/[;=]/=vlc.desktop\n/g' | grep video >> ~/.local/share/applications/mimeapps.list



