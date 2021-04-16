#!/bin/bash

curl -O https://dl.discordapp.net/apps/linux/0.0.14/discord-0.0.14.deb
sudo dpkg -i ./discord-0.0.14.deb
sudo apt install -f -y