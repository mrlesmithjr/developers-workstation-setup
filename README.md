# Developers Workstation Setup

This project is what I use to build out my development workstations. This was
originally part of my [dotfiles](https://github.com/mrlesmithjr/dotfiles) repo,
but I have split this out to keep things more modular.

## Usage

### Clone Repo

First off, clone this repo locally.

```bash
cd ~
git clone https://github.com/mrlesmithjr/developers-workstation-setup.git --recurse-submodules
```

### Setup

Next you will need to kick-off the setup script. Which will do the following:

- Setup [dotfiles](https://github.com/mrlesmithjr/dotfiles)
- Kick of Ansible [playbook](ansible-install-os-packages.yml)
- Setup [time machine exclusions](https://github.com/mrlesmithjr/time_machine_exclusions)

```bash
cd developers-workstation-setup
./setup.sh
```

## License

MIT

## Author Information

Larry Smith Jr.

- [@mrlesmithjr](https://www.twitter.com/mrlesmithjr)
- [EverythingShouldBeVirtual](http://everythingshouldbevirtual.com)
- [mrlesmithjr@gmail.com](mailto:mrlesmithjr@gmail.com)
