# Building ArchUpdate

ArchUpdate is shell scripts and systemd units, packaged with a PKGBUILD.

## Building the package

```sh
cd package
makepkg --syncdeps --force
sudo pacman -U ./archupdate-*.pkg.*
```

`install.sh` does the same thing in a temporary folder, using the PKGBUILD from the `main` branch.

The PKGBUILD clones this repository and copies everything under `root/` into the package. `recipes.sh` enables the timer and the notifier on install and disables them on removal.

## Checks

CI runs:

```sh
shellcheck -S error install.sh package/recipes.sh root/usr/bin/archupdate root/usr/bin/archupdate-notifier
bash -n package/PKGBUILD
```

## Releasing

Installed copies update themselves when `pkgver` in `package/PKGBUILD` on `main` is newer than theirs. Set it to the current time with `date +%s` whenever you push a change to `main`.

## How it works

Every hour, `archupdate.timer` starts `archupdate.service`, which runs `/usr/bin/archupdate`:

1. Checks the conditions: battery at 90% or more, connection not metered (when NetworkManager is installed), and no package database lock from this boot that is less than a day old. A stale lock is removed.
2. Updates ArchUpdate itself, if `main` has a newer `pkgver`.
3. Refreshes the keyrings.
4. Installs repository updates (`pacman -Syu`).
5. Updates AUR packages with yay, if it's installed.
6. Prunes the package cache with `paccache`.

`archupdate-notifier` is a user service that shows a desktop notification at login if the last run failed.

### AUR builds

yay won't run as root, so AUR builds run as a dedicated system account, `archupdate`. It has no password and no login shell, and its home is `/var/lib/archupdate`. The sudoers rule in `/etc/sudoers.d/archupdate` lets only that account run `pacman` without a password, so yay can install what it built.

Prompts are answered automatically: no clean builds, no diff or PKGBUILD review, and make dependencies are removed afterwards. Development (`-git`) packages are rebuilt only when their AUR version changes.

| File | Purpose |
| --- | --- |
| `root/usr/bin/archupdate` | The update script |
| `root/usr/bin/archupdate-notifier` | Login notification after a failed run |
| `root/usr/lib/systemd/system/archupdate.{service,timer}` | Hourly system service |
| `root/usr/lib/systemd/user/archupdate-notifier.service` | User service for the notifier |
| `root/usr/lib/sysusers.d/archupdate.conf` | Creates the `archupdate` account |
| `root/usr/lib/tmpfiles.d/archupdate.conf` | Creates its home folder |
| `root/etc/sudoers.d/archupdate` | Lets that account run pacman |
