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
        r'//.*?$|/\*.*?\*/|\'(?:\\.|[^\\\'])*\'|"(?:\\.|[^\\"])*"',
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
