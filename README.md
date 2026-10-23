# Pacman Auto Update

Keeps all precompiled software packages updated, without user intervention.

Updates are automatically **postponed** under unfavorable conditions:
- 🔋 The **battery** has less than 90% of charge.
- 💸 networkmanager is installed, and the **connection** is guessed as metered.
- 🔒 The package database has a **lock** younger than a day, and older than boot time. Otherwise the lock is automatically removed.

If auto-updating **fails**, a desktop notification appears during login.


## AUR packages

If **yay** is installed, AUR packages are updated too, right after the repository packages (`yay -Sua`).

yay refuses to run as root, so the builds run as a dedicated system account, `pacman-auto-update` (no password, no login shell, home in `/var/lib/pacman-auto-update`). A sudoers rule in `/etc/sudoers.d/pacman-auto-update` lets only that account run `pacman` without a password, so yay can install what it built.

Prompts are answered automatically: no clean builds, no diff or PKGBUILD review, make dependencies removed afterwards. Development (`-git`) packages are only rebuilt when their version in the AUR changes.

⚠️ This means AUR PKGBUILDs are built and installed **without anyone reviewing them**. Only use it if you trust the AUR packages you have installed.


## Installing

In the application **Terminal** enter:

```sh
curl --silent https://raw.githubusercontent.com/Imdabossou/pacman-auto-update/master/install.sh | bash
```

After that the software will be **automatically enabled**, and also it will automatically build and upgrade its **own package**.

Having this program in the **AUR** is not possible right now, simply because its moderators disagree with having any kind of method for automatically upgrading the system.


## Editing update frequency

By default it updates **hourly**.

**Edit** with:
```sh
sudo rnano /usr/lib/systemd/system/pacman-auto-update.timer
```


## Inspecting status

Of the **service**:
```sh
systemctl status pacman-auto-update
```

Of the **timer**:
```sh
systemctl list-timers pacman-auto-update
```

