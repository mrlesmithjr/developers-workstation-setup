# Developers Workstation Setup

This project is what I use to build out my development workstations. This was
originally part of my [dotfiles](https://github.com/mrlesmithjr/dotfiles) repo,
but I have split this out to keep things more modular.

- [Usage](#usage)
  - [Clone Repo](#clone-repo)
  - [Setup](#setup)
  - [Tools](#tools)
  - [Updating Submodules](#updating-submodules)
- [License](#license)
- [Author Information](#author-information)

## Usage

### Clone Repo

First off, clone this repo locally.

```bash
cd ~
git clone https://github.com/mrlesmithjr/developers-workstation-setup.git --recurse-submodules
```

### Setup

Next, you will need to kick off the setup script. Which will do the following:

- Setup [dotfiles]
- Kick-off Ansible [playbook](ansible-install-os-packages.yml)
- Setup [time machine exclusions](https://github.com/mrlesmithjr/time_machine_exclusions)

```bash
cd developers-workstation-setup
./setup.sh
```

### Tools

Over time I'll be adding some useful tools that I use in the [tools](tools/)
directory. These are all added as submodules which may over time be out of date.
But I'll do my best to keep them updated. However you can also update them as
you wish by [updating submodules](#updating-submodules).

### Updating Submodules

Because many different components within this repository are submodules. They may over time become out of date. You can update them by
executing the following:

```bash
git submodule update --remote --init --recursive
```

## License

MIT

## Author Information

Larry Smith Jr.

- [@mrlesmithjr](https://www.twitter.com/mrlesmithjr)
- [EverythingShouldBeVirtual](http://everythingshouldbevirtual.com)
- [mrlesmithjr@gmail.com](mailto:mrlesmithjr@gmail.com)
