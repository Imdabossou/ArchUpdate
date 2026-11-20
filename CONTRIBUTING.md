# Contributing to ArchUpdate

Thanks for helping! A few things to know first.

- **Bugs:** open an issue with the output of `journalctl -u archupdate` for the failing run, and say whether yay is installed.
- **Branches:** open pull requests against `development`. `main` only gets tested changes, and every installed copy updates itself from it.
- **Checks:** `shellcheck -S error` on every script and `bash -n package/PKGBUILD` must pass. CI runs both. See [BUILDING.md](BUILDING.md).
- **Safety first:** the scripts run as root every hour on other people's machines. Changes must not remove packages automatically, widen the sudoers rule, or `eval` anything that comes from package names or command output.
- **Upstream fixes:** if a bug also affects [pacman-auto-update](https://github.com/cmuench/pacman-auto-update), consider reporting it there too.
- **Licence:** contributions are accepted under the project's licence (GPL-2.0).
- **Security issues:** please report them privately, see [SECURITY.md](SECURITY.md).
