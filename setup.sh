#!/usr/bin/env bash
set -e
set -x

# Define location of where we are cloned to and executed from
BUILD_DIR="$PWD"

# Define where dotfiles repo exists
DOTFILES_DIR="$HOME/.dotfiles"

if [ ! -d "$DOTFILES_DIR" ]; then
  git clone https://github.com/mrlesmithjr/dotfiles-new "$DOTFILES_DIR" --recurse-submodules
  source "$DOTFILES_DIR/setup.sh"
  git config --global user.name ""
  git config --global user.email ""
fi

#### Python Virtual Environment Setup ####
# Setup a default Python virtual environment to use rather than installing
# everything in system
DEFAULT_PYTHON_VERSION="3"
VIRTUALENV_DIR="$HOME/.python-virtualenvs"
DEFAULT_VIRTUALENV="$VIRTUALENV_DIR/default"
PYTHON3_VIRTUALENV_DIR="$VIRTUALENV_DIR/default-python3"
PYTHON_PIP_CMD="pip$DEFAULT_PYTHON_VERSION"

# Check to ensure virtualenv command exists
command -v virtualenv >/dev/null 2>&1
VIRTUALENV_CMD_CHECK=$?
if [ $VIRTUALENV_CMD_CHECK -ne 0 ]; then
  if [[ $(uname) == "Darwin" ]]; then
    $PYTHON_PIP_CMD install virtualenv
  elif [[ $(uname) == "Linux" ]]; then
    sudo $PYTHON_PIP_CMD install virtualenv
  fi
fi

# Create Python3 default virtualenv
if [ ! -d "$PYTHON3_VIRTUALENV_DIR" ]; then
  if [ -f /etc/debian_version ] || [ -f /etc/redhat-release ]; then
    python3 -m venv --system-site-packages "$PYTHON3_VIRTUALENV_DIR"
  else
    python3 -m venv "$PYTHON3_VIRTUALENV_DIR"
  fi
  # shellcheck source=/dev/null
  source "$PYTHON3_VIRTUALENV_DIR"/bin/activate
  $PYTHON_PIP_CMD install --upgrade pip
  deactivate
fi

# Setup Python Virtual Environment dirs
if [ -d "$DEFAULT_VIRTUALENV" ] && [ ! -L "$DEFAULT_VIRTUALENV" ]; then
  mv "$DEFAULT_VIRTUALENV" "$DEFAULT_VIRTUALENV".backup
  ln -s "$PYTHON3_VIRTUALENV_DIR" "$DEFAULT_VIRTUALENV"
elif [ ! -d "$DEFAULT_VIRTUALENV" ]; then
  ln -s "$PYTHON3_VIRTUALENV_DIR" "$DEFAULT_VIRTUALENV"
elif [ -L "$DEFAULT_VIRTUALENV" ]; then
  if [[ "$DEFAULT_VIRTUALENV" -ef "$PYTHON3_VIRTUALENV_DIR" ]]; then
    :
  else
    rm "$DEFAULT_VIRTUALENV"
    ln -s "$PYTHON3_VIRTUALENV_DIR" "$DEFAULT_VIRTUALENV"
  fi
fi

# Source our default Python virtual environment
# shellcheck source=/dev/null
source "$DEFAULT_VIRTUALENV"/bin/activate

set +e
command -v ansible >/dev/null 2>&1
ANSIBLE_CHECK=$?
if [ $ANSIBLE_CHECK -eq 0 ]; then
  echo "Ansible already installed"
else
  $PYTHON_PIP_CMD install ansible
fi

cd "$BUILD_DIR"
ansible-playbook ansible-install-os-packages.yml -K
# ansible-playbook "$DOTFILES_DIR"/install/macos_defaults.yml
