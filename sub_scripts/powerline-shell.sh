#!/bin/bash

sudo apt install -y fonts-powerline
pip3 install powerline-shell

INSTALLED=`cat ~/.zshrc | grep "powerline-shell" | wc -l`
if [ "$INSTALLED" = "0" ]
then
    echo ""                                                                  >> ~/.zshrc
    echo "# https://github.com/jclarte/linux-mint-postinstall"               >> ~/.zshrc
    echo 'function _update_ps1() {'                                          >> ~/.zshrc
    echo '    PS1=$(powerline-shell $?)'                                     >> ~/.zshrc
    echo '}'                                                                 >> ~/.zshrc
    echo ''                                                                  >> ~/.zshrc
    echo 'if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then' >> ~/.zshrc
    echo '    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"'                 >> ~/.zshrc
    echo 'fi'                                                                >> ~/.zshrc
fi
