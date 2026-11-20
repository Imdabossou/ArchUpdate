# AGENTS.md

Hourly automatic updates for Arch Linux: pacman, then AUR packages through yay. Bash scripts, systemd units and a PKGBUILD. Fork of pacman-auto-update, GPL-2.0.

## Commands

- Checks: `shellcheck -S error install.sh package/recipes.sh root/usr/bin/archupdate root/usr/bin/archupdate-notifier` and `bash -n package/PKGBUILD`
- Build and install locally: `cd package && makepkg --syncdeps --force && sudo pacman -U ./archupdate-*.pkg.*`
- Logs: `journalctl -u archupdate`
- More in [BUILDING.md](BUILDING.md)

## Conventions

- Branches: work on `development`; `main` only gets tested changes. Installed copies follow `main`.
- Bump `pkgver` in `package/PKGBUILD` (`date +%s`) with every change that reaches `main`, or installed copies won't update.
- Keep the PKGBUILD source as `${pkgname}::git+${url}`. The repository name (ArchUpdate) differs from the package name (archupdate).
- Never add automatic removal of orphaned packages. It was removed on purpose: the upstream version used `eval` in a way that could run package names as root commands.
- The `archupdate` account may only run `pacman` through sudo. Don't widen the sudoers rule.
- Keep the credits to the upstream authors in README.md.

## Traps

- Everything runs as root from a timer, so treat any input (package names, command output) as data. Never `eval` it.
- Testing the real service needs an Arch system and root. Don't run it on a machine where an unexpected update or reboot would cause trouble.
