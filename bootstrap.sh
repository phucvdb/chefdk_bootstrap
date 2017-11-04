#!/bin/sh
#set -v
#This script is to install chefdk_bootstrap on Ubuntu

#Initialization
chefDKstatus="$(sudo dpkg -s chefdk  | grep Status | awk '{print $2 $3 $4}')"
package="chefdk_2.3.4-1_amd64.deb"
sha256="$(curl --silent --show-error 'https://omnitruck.chef.io/stable/chefdk/metadata?p=ubuntu&pv=16.04&m=x86_64&v=latest' | grep sha256 | awk '{print $2}')"
chefdkURL="$(curl --silent --show-error 'https://omnitruck.chef.io/stable/chefdk/metadata?p=ubuntu&pv=16.04&m=x86_64&v=latest' | grep url | awk '{print $2}')"   
bootstrapUrl="https://github.com/phucvdb/chefdk_bootstrap/archive/master.zip"
installationPath="/tmp/teracy"

if [ ! -d $installationPath ] ; then 
    mkdir $installationPath
fi
cd $installationPath

if [ $chefDKstatus = "installokinstalled" ] ; then
    echo "$package is installed"
else
    wget -c $chefdkURL
    if [ -f $package ] ; then
        sudo dpkg -i $package
        if [ $? -ne 0 ] ; then
            echo "Error installing $package"
            exit
        fi
    else
        echo "$package is not existing, please check your network"
        exit
    fi
fi

#Download and unzip the cookbook from Github
wget -O teracybootstrap.zip $bootstrapUrl
unzip teracybootstrap.zip -d teracy_bootstrap

#update the chefConfigPath and jump to it
chefConfigPath="$installationPath/teracy_bootstrap/chefdk_bootstrap-master/"
cd $chefConfigPath

#load the cookbook dependencies
berks vendor
if [ $? -ne 0 ] ; then
    echo "$? Error running berks to download cookbooks dependencies"
    exit
fi

sudo chef-client -z -l error -c ./client.rb -o teracydev_installation
if [ $? -ne 0 ] ; then
    echo "Error running chef-client."
    exit
fi

vagrant plugin install vagrant-gatling-rsync
if [ $? -ne 0 ] ; then
    echo "Error installing vagrant-gatling-rsync."
    exit
fi

vagrant plugin install vagrant-rsync-back
if [ $? -ne 0 ] ; then
    echo "Error installing vagrant-rsync-back."
    exit
fi


# Cleanup
sudo rm -rf $installationPath