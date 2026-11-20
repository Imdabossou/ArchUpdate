# ArchUpdate

**Keeps your Arch Linux system updated in the background, AUR packages included.**

Every hour, ArchUpdate installs repository updates with pacman and AUR updates with yay. You don't have to do anything.

## Features

- **Hourly updates** from the repositories, and from the AUR if yay is installed
- **Waits when it should**: on low battery, on a metered connection, or while another package manager is running
- **Tells you if something fails**, with a desktop notification at your next login
- **Keeps the cache tidy**: the last two versions of each package, none of uninstalled ones
- **Keeps keyrings fresh** so signature checks keep working
- **Never removes packages** on its own. You decide what to uninstall
- **Updates itself** when a new version is released

> [!WARNING]
> AUR packages are built and installed **without anyone reviewing their PKGBUILDs**. Only use ArchUpdate if you trust the AUR packages you have installed.

## Install

```sh
curl --silent https://raw.githubusercontent.com/Imdabossou/ArchUpdate/main/install.sh | bash
```

This builds and installs the `archupdate` package, then turns on the hourly timer and the login notifier.

## Useful commands

```sh
systemctl list-timers archupdate              # when it runs next
journalctl -u archupdate                      # what it did
sudo rnano /usr/lib/systemd/system/archupdate.timer   # change how often it runs
```

## Credits and licence

ArchUpdate is a renamed and extended fork of [pacman-auto-update](https://github.com/cmuench/pacman-auto-update) by Christian Münch, Alberto Salvia Novella, Nico Tonnhofer and its other contributors. It adds AUR updates through yay and stops removing orphaned packages.

Licensed under the [GPL-2.0](LICENSE), like the original. How it works and how to build it: [BUILDING.md](BUILDING.md).
