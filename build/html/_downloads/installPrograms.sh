#!/bin/bash

# this script has been written for installing needed software on the test gateway  conviniently

apt-get update 
apt-get install curl
curl -sSL get.docker.com | sh
apt-get install dnsmasq ufw libftdi-dev python-dev python-pip 
pip install rpi.gpio

