#!/bin/bash

sudo apt install -y python3-pip python3-venv python3-dev

sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt update -y
sudo apt install -y python3.10 python3.10-venv python3.10-dev

# install pipx
pip install --user --upgrade pipx
pipx ensurepath --force
export PATH=$PATH:~/.local/bin

# install userpath
pipx install userpath
pipx upgrade userpath

# install python-dev-tools
pipx install python-dev-tools
pipx upgrade python-dev-tools
TOOLS_PATH=$(ls -l ~/.local/bin/whataformatter | sed -e "s/.*-> //" | sed -e "s#/bin.*#/bin#")
userpath prepend $TOOLS_PATH

# install & setup anaconda
curl -O https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh
echo "#########################"
echo "# Anaconda installation #"
echo "#########################"
bash ./Anaconda3-2020.11-Linux-x86_64.sh
conda init bash
conda update -n base -c defaults conda
conda create -n ai_env tensorflow-gpu scikit-learn numpy scipy matplotlib ipython jupyter pandas sympy nose
conda create -n web_env django flask
conda create -n game_env
conda activate game_env
pip install pygame
conda deactivate
