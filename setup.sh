#!/usr/bin/env bash
set -e
set -x

# Define location of where we are cloned to and executed from
BUILD_DIR="$PWD"

# Define where dotfiles repo exists
DOTFILES_DIR="$HOME/.dotfiles"
# Define dotfiles remote repo
DOTFILES_REPO="https://github.com/mrlesmithjr/dotfiles.git"

# First we need to check and see if the original dotfiles repo structure is in
# place. If it is, back it up and clone the new structure and setup.
if [ ! -d "$DOTFILES_DIR" ]; then
	git clone "$DOTFILES_REPO" "$DOTFILES_DIR" --recurse-submodules
	# shellcheck source=/dev/null
	source "$DOTFILES_DIR/install"
	git config --global user.name ""
	git config --global user.email ""
else
		cd "$DOTFILES_DIR"
		git fetch
		git pull
		git submodule update --remote --recursive
		# shellcheck source=/dev/null
		source "$DOTFILES_DIR/install"
		cd "$DOTFILES_DIR"
fi

export PYENV_ROOT="$HOME/.pyenv"

if [ ! -d "$PYENV_ROOT" ]; then
	git clone https://github.com/pyenv/pyenv.git "$PYENV_ROOT"
	git clone https://github.com/pyenv/pyenv-virtualenv.git "$PYENV_ROOT/plugins/pyenv-virtualenv"
	export PATH="$PYENV_ROOT/bin:$PATH"
	DEFAULT_PYTHON_VERSION=$(pyenv install --list | grep -v - | grep -v b | grep -v mini | grep -v rc | tail -1 | awk '{ print $1 }')
	pyenv install "$DEFAULT_PYTHON_VERSION"
	pyenv global "$DEFAULT_PYTHON_VERSION"
	eval "$(pyenv init --path)"
	eval "$(pyenv init -)"
	pip install --upgrade pip pip-tools
	pip-sync "$DOTFILES_DIR/requirements.txt"
else
	export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init --path)"
	eval "$(pyenv init -)"
fi

# Check for existing Python virtualenv called ansible-system on Linux
if [[ $(uname) == "Linux" ]]; then
	# Get current Python version from pyenv
	CURRENT_PYTHON_VERSION=$(pyenv version | awk '{ print $1 }')
	pyenv versions | grep ansible-system
	if [ $? -eq 1 ]; then
		pyenv global system
		pyenv virtualenv --system-site-packages ansible-system
	fi
	pyenv global ansible-system
	pip3 install --upgrade pip
	pip3 install -r "$DOTFILES_DIR/requirements.txt"
	cd "$BUILD_DIR"
	ansible-playbook ansible-install-os-packages.yml -K
	pyenv global $CURRENT_PYTHON_VERSION
else
	cd "$BUILD_DIR"
	ansible-playbook ansible-install-os-packages.yml -K
fi

# If running on macOS, setup Time Machine Exclusions
if [[ $(uname) == "Darwin" ]]; then
	if [ -d "$BUILD_DIR/tools/time_machine_exclusions" ]; then
		if [ -f "$BUILD_DIR/tools/time_machine_exclusions/install.sh" ]; then
			cd "$BUILD_DIR/tools/time_machine_exclusions"
			# shellcheck source=/dev/null
			source install.sh
		fi
	fi
fi

cd "$BUILD_DIR"
