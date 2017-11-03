#!/bin/sh
#set -v
#This script is to install chefdk_bootstrap on Ubuntu

#Initialization
chefDKstatus="$(sudo dpkg -s chefdk  | grep Status | awk '{print $2 $3 $4}')"
package="chefdk_2.3.4-1_amd64.deb"
sha256="$(curl --silent --show-error 'https://omnitruck.chef.io/stable/chefdk/metadata?p=ubuntu&pv=16.04&m=x86_64&v=latest' | grep sha256 | awk '{print $2}')"
chefdkURL="$(curl --silent --show-error 'https://omnitruck.chef.io/stable/chefdk/metadata?p=ubuntu&pv=16.04&m=x86_64&v=latest' | grep url | awk '{print $2}')"   

if [ $chefDKstatus == "installokinstalled" ] ; then
    echo "$package is installed"
else
    wget -c $chefdkURL
    if [ -f $package ] ; then
        sudo dpkg -i $package
    else
        echo "$package is not existing, please check your network"
    fi
fi
