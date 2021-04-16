#!/bin/bash

# curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
# sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
# sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list



sudo apt update -y
sudo apt install -y codium
# sudo chown -R $(whoami) /usr/share/code

# Use --force to update? Seems it doesn't work.
codium --install-extension ms-python.python
codium --install-extension visualstudioexptteam.vscodeintellicode
codium --install-extension ms-vscode.cpptools
codium --install-extension coenraads.bracket-pair-colorizer
codium --install-extension compulim.compulim-vscode-closetag
codium --install-extension batisteo.vscode-django
codium --install-extension bibhasdn.django-html
codium --install-extension donjayamanne.githistory
codium --install-extension yzhang.markdown-all-in-one
codium --install-extension davidanson.vscode-markdownlint
codium --install-extension dongli.python-preview
codium --install-extension lextudio.restructuredtext
codium --install-extension gruntfuggly.todo-tree
# codium --install-extension vscodevim.vim
codium --install-extension vscode-icons-team.vscode-icons
codium --install-extension tomoki1207.pdf
codium --install-extension dotjoshjohnson.xml
codium --install-extension bungcip.better-toml
codium --install-extension grapecity.gc-excelviewer
codium --install-extension ms-pyright.pyright


#############################################
# Add open folder in VS code in contextual menu
#############################################

cat <<EOT > ~/.local/share/nemo/actions/vscodium.nemo_action
[Nemo Action]
Name=Ouvrir dans VS Codium
Comment=Ouvrir dans VS Codium
Exec=codium %F
Icon-Name=visual-studio-code
Selection=Any
Extensions=dir;
EOT

#############################################
# Configure VS code
#############################################

# first install Python, to parse easily JSON
# DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# eval "$DIR/python.sh"

# create python script
cat <<EOT > config_vscodium.py
import json
import re
from pathlib import Path

home = Path.home()
config_json = home / ".config/Codium/User/settings.json"


def comment_remover(text):
    def replacer(match):
        s = match.group(0)
        if s.startswith("/"):
            return " "  # note: a space and not an empty string
        else:
            return s

    pattern = re.compile(
        r'//.*?$|/\*.*?\*/|\'(?:\\\\.|[^\\\\\\'])*\'|"(?:\\\\.|[^\\\\"])*"',
        re.DOTALL | re.MULTILINE,
    )
    return re.sub(pattern, replacer, text)


config = {}
try:
    with open(config_json, encoding="utf-8") as file:
        content = file.read()
        content = comment_remover(content)
        config = json.loads(content)
except FileNotFoundError:
    pass

config["breadcrumbs.enabled"] = True
config["diffEditor.ignoreTrimWhitespace"] = False
config["editor.cursorStyle"] = "line"
config["editor.formatOnSave"] = True
config["editor.formatOnPaste"] = True
config["files.watcherExclude"] = {
    "**/.tox/**": True,
    "**/venv/**": True,
    "**/build/**": True,
    "**/.git/objects/**": True,
    "**/.git/subtree-cache/**": True,
    "**/node_modules/*/**": True,
}
config["python.editor.formatOnPaste"] = False
config["python.pythonPath"] = "/usr/bin/python3.8"
config["python.linting.enabled"] = True
config["python.linting.flake8Enabled"] = True
config["python.linting.flake8Path"] = f"~/.local/bin/whatalinter"
config["python.formatting.provider"] = "black"
config["python.formatting.blackPath"] = "~/.local/bin/whataformatter"
config["python.formatting.blackArgs"] = []
# TODO supprimer ces deux lignes
config[
    "python.formatting.blackPath"
] = "~/.local/pipx/venvs/python-dev-tools/bin/black"
config["python.formatting.blackArgs"] = [
    "--line-length",
    "79",
    "--target-version=py36",
]
config["scm.defaultViewMode"] = "tree"
config["terminal.integrated.rendererType"] = "dom"
# config["vim.incsearch"] = True
# config["vim.useSystemClipboard"] = True
# config["vim.hlsearch"] = True
# config["vim.handleKeys"] = {"<C-a>": False, "<C-f>": False}
config["window.titleBarStyle"] = "custom"
config["workbench.colorTheme"] = "Visual Studio Dark"
config["workbench.iconTheme"] = "vscode-icons"

if config:
    with open(config_json, encoding="utf-8", mode="w") as file:
        json.dump(config, file, indent=4)
EOT

python3.10 config_vscodium.py
