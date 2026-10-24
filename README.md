# ArchUpdate

Keeps your Arch Linux system updated in the background: repository packages through pacman, and AUR packages through yay. You don't have to do anything.


## What it does

Every hour, ArchUpdate:

1. Refreshes the keyrings so signature checks keep working.
2. Downloads and installs all repository updates (`pacman -Syu`).
3. Updates AUR packages with yay, if yay is installed.
4. Prunes the package cache with `paccache`, keeping the last two versions of each installed package and none of uninstalled ones.
5. Updates itself when a newer version is pushed to this repository.

Updates **wait** when conditions aren't good:
- 🔋 The **battery** is below 90%.
- 💸 NetworkManager is installed and the **connection** looks metered.
- 🔒 The package database has a **lock** from this boot that is less than a day old. A stale lock is removed automatically.

If an update **fails**, a desktop notification appears when you next log in.

Orphaned packages are **never** removed automatically. You decide what to uninstall.


## AUR packages

yay won't run as root, so AUR builds run as a dedicated system account, `archupdate`. It has no password, no login shell, and its home is `/var/lib/archupdate`. A sudoers rule in `/etc/sudoers.d/archupdate` lets only that account run `pacman` without a password, so yay can install what it built.

Prompts are answered automatically: no clean builds, no diff or PKGBUILD review, and make dependencies are removed afterwards. Development (`-git`) packages are rebuilt only when their AUR version changes.

⚠️ This means AUR PKGBUILDs are built and installed **without anyone reviewing them**. Only use this if you trust the AUR packages you have installed.


## Installing

In a terminal, run:

```sh
curl --silent https://raw.githubusercontent.com/Imdabossou/ArchUpdate/master/install.sh | bash
```

This builds and installs the `archupdate` package, then turns on the timer and the login notifier.


## Changing how often it runs

By default it runs **hourly**. To change that, edit the timer:

```sh
sudo rnano /usr/lib/systemd/system/archupdate.timer
```


## Checking status

The **service**:
```sh
systemctl status archupdate
```

The **timer**:
```sh
systemctl list-timers archupdate
```

The **log**:
```sh
journalctl -u archupdate
```


## Credits

ArchUpdate is a renamed and extended fork of [pacman-auto-update](https://github.com/cmuench/pacman-auto-update) by Christian Münch, Alberto Salvia Novella, Nico Tonnhofer and its other contributors. The original handles repository updates, the update conditions, keyring refreshes and the failure notifier. ArchUpdate adds AUR updates through yay and stops removing orphaned packages.

It is licensed under the GPL-2.0, like the original. See [LICENSE](LICENSE).
