#!/bin/bash
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo add-apt-repository ppa:lutris-team/lutris
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y nvidia-driver-450
sudo apt install -y libvulkan1 libvulkan1:i386

# install lutris bytw
sudo apt install -y lutris
