# SnoDots
Algebraic!

# Tech Used
I'm using the wonderful [Homemaker](https://github.com/FooSoft/homemaker) bundled within the repo to read the TOML file, defs.tml

## Variants
Homemaker's variants are used with the original author's examples -- to vary the install based on OS.

## Modules
Modules are my layer on top of variants, lazily implemented by calling the speedy Homemaker tool with different args with install.sh. Modules allow me to vary which features are provided based on privileges, resources, and purpose of the machine.

For example, I won't install zsh syntax highlighting on a low-resource shell, and I won't install work stuff on my personal machines.

## Task naming
I name tasks in three different patterns:

- \[name\] - "modpacks" which call multiple other tasks
- install_\[name\] - install the packages related to \[name\]
- setup_\[name\] - place the dotfiles related to \[name\]

This is to allow easy use on systems on which I do not have privileges

# License
Each line of code is written by myself or other people. No code, to my knowledge, has a license explicitly attached to it.

Therefore, feel free to use the repository for personal use. Don't try to use the code commercially.
