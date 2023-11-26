# Change Log

All notable changes to this project will be documented in this file.  
The format is based on [Keep a Changelog](http://keepachangelog.com/).

## [v4.1.0](https://gitlab.com/nodiscc/dlc/releases/tag/4.1.0) - UNRELEASED

### Added
- packages: system/package management: add gnome-package-updater (`gpk-update-viewer`)
- system: add firmware for Realtek, Atheros, Broadcom and Intel Wi-Fi devices

### Removed
- network: remove [Pidgin](https://pidgin.im/) instant messaging client

### Changed
- grub: enable auto-detection of other Operating Systems (dual-boot configurations)
- firefox: update user.js to v0.9.0 (UI: replace the window title bar with the tabs bar)
- update documentation

---------------------

## [v4.0.0](https://gitlab.com/nodiscc/dlc/releases/tag/4.0.0) - 2023-07-13

**Upgrade procedure:** Follow the official [Debian upgrade procedure](https://www.debian.org/releases/bookworm/amd64/release-notes/ch-upgrading.html), or backup your data, reinstall, and restore. Note: some changes will only take effect after creating a new user account. If upgrading without reinstalling, you will need to apply some of the changes below (notably add/remove packages) manually.

### Added
- config: add the [`non-free-firmware`](https://wiki.debian.org/Firmware) component to APT sources list
- packages: utility: add [alarm-clock-applet](https://packages.debian.org/bookworm/alarm-clock-applet)
- skel: bash: add an alias `gss` to show the status of git repositories under `~/GIT` using `mgitstatus`

### Changed
- rebase on [Debian 12 "Bookworm"](https://www.debian.org/releases/bookworm/)
- config: enable tap-to-click by default for all touchpads
- config: xfce4-panel: set clock panel plugin font to Roboto 9, set clock format to `HH:MM`
- config: autostart: disable alarm-clock-applet autostart
- config: remove catfish file search from Thunar custom actions and xfce4-whiskermenu favorites (Thunar file manager now has a native file search feature)
- config: xsettings: sync xfwm4 theme to GTK theme changes if possible
- config: use long date format to display dates in Thunar file manager
- config: remove pidgin from whiskermenu favorites
- config: remove custom wallpapers/backgrounds, use the new Debian 12 "Emerald" theme everywhere
- firefox: disable Mozilla VPN ads, re-enable WebGL full capability mode and extensions, display bookmarks toolbar by default, display separate search/location bars by default, disable Firefox studies (Shield), set the default search engine to DuckDuckGo instead of Google (update [user.js](https://gitlab.com/nodiscc/user.js) to v0.8.0)
- cleanup: packages: update package names to their Debian 12 names
- tests: update test tooling
- doc: update documentation

### Removed
- packages: system: remove [hddtemp](https://packages.debian.org/bullseye/hddtemp) - can be replaced with the `drivetemp` kernel module (`sudo modprobe drivetemp; sudo sensors`)
- packages: graphics: remove [gimp-gap](https://packages.debian.org/bullseye/gimp-gap) (removed from Debian)
- packages: network: remove [telegram-purple](https://packages.debian.org/bullseye/telegram-purple) (removed from Debian) and [purple-discord](https://packages.debian.org/bullseye/purple-discord) and [purple-rocketchat](https://packages.debian.org/bullseye/purple-rocketchat), [pidgin-opensteamworks](https://github.com/EionRobb/pidgin-opensteamworks)
- packages: audio/video: remove [subliminal](https://packages.debian.org/bullseye/subliminal)
- packages: games: remove [lutris](https://packages.debian.org/bullseye/lutris) (removed from Debian)
- packages: development: remove [checkinstall](https://packages.debian.org/bullseye/checkinstall), [fakeroot](https://packages.debian.org/bullseye/fakeroot), [reportbug](https://packages.debian.org/bullseye/reportbug), [meld](https://packages.debian.org/bullseye/meld)
- cleanup/packages: remove obsolete packages whose functionality is now included in core packages (`libreoffice-avmedia-backend-gstreamer`, `crda`, `gvfs-bin`)

### Fixed
- fix XFCE power manager unable to suspend the system on laptop lid close/low battery

---------------------

## [v3.1.1](https://gitlab.com/nodiscc/dlc/releases/tag/3.1.1) - 2022-11-11

### Removed
- remove [nextcloud-desktop](https://packages.debian.org/bullseye/nextcloud-desktop) to decrease .ISO image size
- remove [zenity](https://packages.debian.org/bullseye/zenity) to decrease .ISO image size
- extras: remove [Signal Desktop](https://signal.org/download/) to decrease .ISO image size
- remove unfrequently used `firmware-netronome` to decrease image .ISO size

### Fixed
- decrease ISO image size to <2GB to allow upload on github releases

---------------------

## [v3.1.0](https://gitlab.com/nodiscc/dlc/releases/tag/3.1.0) - 2022-11-08

### Added
- extras: add [Signal Desktop](https://signal.org/download/) encrypted messaging client
- extras: add [Thunderbird Conversations](https://addons.thunderbird.net/thunderbird/addon/gmail-conversation-view/) extension
- packages: development: add [mgitstatus](https://github.com/fboender/multi-git-status) (show status of multiple Git repositories)

### Changed
- update all packages to latest Debian Stable versions
- update documentation

---------------------

## [v3.0.1](https://gitlab.com/nodiscc/dlc/releases/tag/3.0.1) - 2022-09-01

### Added
- packages: system/virtualization: add [libguestfs-tools](https://packages.debian.org/libguestfs-tools), [virt-p2v](https://packages.debian.org/virt-p2v), [libguestfs-rsync](https://packages.debian.org/libguestfs-rsync), [libguestfs-rescue](https://packages.debian.org/libguestfs-rescue)
- packages: internet: add [purple-discord](https://packages.debian.org/bullseye/purple-discord) (Discord messaging service plugin for pidgin/libpurple)

### Removed
- packages: remove [gnome-clocks](https://packages.debian.org/bullseye/gnome-clocks)
- packages: remove NVIDIA proprietary drivers from the default installation

### Changed
- update all packages to latest stable versions
- no longer install Linux kernel/firmware and NVIDIA drivers from backports, use versions from Debian Stable
- defaults/skel: autostart keepassxc on login
- defaults/skel: enable KeepassXC/Firefox integration by default
- defaults/skel: add keyboard shortcuts to tile the active window left/right/top right/bottom right (`Super+Left/Right/Up/Down`)
- defaults/skel: `.gitconfig`: remember git HTTP credentials, use rebase mode by default for `git pull`
- packages: install yt-dlp from [debian backports](https://packages.debian.org/bullseye-backports/yt-dlp) instead of [third-party](https://nodiscc.gitlab.io/toolbox/) repository
- firefox: always show the bookmarks toolbar (update [user.js](https://gitlab.com/nodiscc/user.js) to v0.4.0)

### Fixed
- fix boot in legacy BIOS mode (`Failed to load COM32 file vesamenu.c32`)
- fix unattended-upgrades configuration (automatically update packages from Debian Backports)
- fix XFCE power manager unable to suspend the system on laptop lid close/low battery

### Upgrade procedure

If you have a system installed from a previous version of `debian-live-config`:

- Recommended: [Backup](https://apps.gnome.org/app/org.gnome.DejaDup/) user data, [download](https://debian-live-config.readthedocs.io/en/latest/download-and-installation.html) the latest ISO image, reinstall (overwrite the existing installation), restore data from backups
- To upgrade without reinstalling:

```bash
# remove (or comment out) APT pinning configuration
sudo rm /etc/apt/preferences.d/99backports
# force downgrade of kernel/nvidia-driver to the stable version
sudo nano /etc/apt/preferences.d/99downgrade-backports
```

```bash
# paste this to /etc/apt/preferences.d/99downgrade-backports, save and exit
# always use kernel, firmware and nvidia drivers from stable
Package: linux-image-*
Pin: release a=bullseye
Pin-Priority: 1000

Package: linux-headers-*
Pin: release a=bullseye
Pin-Priority: 1000

Package: firmware-*
Pin: release a=bullseye
Pin-Priority: 1000

Package: nvidia-*
Pin: release a=bullseye
Pin-Priority: 1000
```

- Optionally, update your configuration according to [changes since the last release](https://gitlab.com/nodiscc/debian-live-config/-/compare/3.0.0...3.0.1). Changes to  `/etc/skel` will only take effect after creating a new user account.

---------------------

## [v3.0.0](https://gitlab.com/nodiscc/dlc/releases/tag/3.0.0) - 2021-10-28

### Changed

- rebase on [Debian 11.1.0 "Bullseye"](https://www.debian.org/releases/bullseye/)
- doc: increase RAM requirements to 2GB/recommended 4GB
- apt: update APT sources lists/configuration
- replace [backintime](https://packages.debian.org/bullseye/backintime-qt) backup tool with [deja-dup](https://wiki.gnome.org/Apps/DejaDup)
- games: install lutris from official Debian repositories, remove third-party package download
- extras: use `.deb` packages to manage additional/unofficial software ([bleachbit-cleanerml](https://github.com/bleachbit/cleanerml), [yt-dlp](https://github.com/yt-dlp/yt-dlp), [pidgin-opensteamworks](https://github.com/eionrobb/pidgin-opensteamworks), [user.js](https://gitlab.com/nodiscc/user.js)), remove custom installation logic, update all extra packages to latest releases
- network/audio-video: replace [youtube-dl](https://packages.debian.org/bullseye/youtube-dl)/[streamlink](https://packages.debian.org/bullseye/streamlink) with [yt-dlp](https://github.com/yt-dlp/yt-dlp) ([third-party package](https://nodiscc.gitlab.io/toolbox/))
- skel: update and fix [conky](https://packages.debian.org/bullseye/conky-all) configuration for recent versions
- skel/session: don't autostart blueman bluetooth manager by default
- skel/session: don't autostart keepassxc by default
- skel: update default UI configuration for thunar, ristretto, xfce4-desktop, xfce4-panel
- skel: replace xfce4-power-manager notification icon with battery panel plugin
- skel: xfwm4: enable video compositing by default (transparency effects)
- skel: xfwm4: disable confusing "Use mouse wheel on title bar to roll up the window" setting
- skel: thunar: add custom right-click menu actions to restore files/directories with deja-dup, and analyze disk usage (baobab) in the selected directory
- skel: vlc: don't ask for network metadata access, disable it by default
- prevent PC speaker beep when logging out of desktop sessions
- reduce ISO image size (don't keep APT indices on the live filesystem)
- doc: update user/maintainer documentation/download links
- doc: installation: rotate GPG key (old key expired)
- doc: update alternative/suggested packages list, remove packages no longer available in Debian 11
- skel/desktop: update backgrounds/themes for Debian 11
- skel: update default bash aliases (alias `diff` to `colordiff`, don't alias `diff`)
- tools: update tests/build configuration and automation tools, make build completely non-interactive
- system/config: enable UFW firewall at boot by default
- enable plymouth boot screen by default in the installed system

### Added

- network: add support for more protocols in pidgin instant messenger: [Discord](https://packages.debian.org/bullseye/purple-discord), [Telegram](https://packages.debian.org/bullseye/telegram-purple), [Rocket.Chat](https://packages.debian.org/bullseye/purple-rocketchat), XMPP [HTTP upload](https://packages.debian.org/bullseye/purple-xmpp-http-upload) and [message carbons](https://packages.debian.org/bullseye/purple-xmpp-carbons), [OMEMO encryption](https://packages.debian.org/bullseye/purple-lurch)
- graphics: add [gcolor3](https://packages.debian.org/bullseye/gcolor3) color picker
- doc: add [Software: Extras](https://debian-live-config.readthedocs.io/en/latest/packages/extras.html) page listing all third-party downloads
- add live system language selection and custom theme in live media UEFI bootloader (GRUB)

### Removed

- system: remove [primus](https://packages.debian.org/bullseye/primus) (conflicts with nvidia drivers), [irqbalance](https://packages.debian.org/bullseye/irqbalance) (unused, 
- utilities: remove [xfce4-notes](https://packages.debian.org/buster/xfce4-notes) (package was removed from Debian 11)
- remove less used/unused packages by default, reduce dependencies and image size: [asunder](https://packages.debian.org/bullseye/asunder) (audio CD ripper), [xfburn](https://packages.debian.org/bullseye/xfburn) (CD/DVD burning), [libasound2-plugin-equal](https://packages.debian.org/bullseye/libasound2-plugin-equal) (can be replaced with [pulseaudio-equalizer](https://packages.debian.org/bullseye/pulseaudio-equalizer)),  [gimp-gmic](https://packages.debian.org/bullseye/gimp-gmic) (image processing utilities), [pulseaudio-module-zeroconf](https://packages.debian.org/bullseye/pulseaudio-module-zeroconf), [pandoc](https://packages.debian.org/bullseye/pandoc) (documentation generator), [advancecomp](https://packages.debian.org/bullseye/advancecomp) (compression utilities), [blender](https://packages.debian.org/bullseye/blender) (3D editor), [shellcheck](https://packages.debian.org/bullseye/shellcheck), [asciinema](https://packages.debian.org/bullseye/asciinema), [gnome-settings-daemon](https://packages.debian.org/bullseye/gnome-settings-daemon), [wine](https://packages.debian.org/bullseye/wine) (let lutris manage wine versions/architectures), [inkscape](https://packages.debian.org/bullseye/inkscape) vector editor, [pstoedit](https://packages.debian.org/bullseye/pstoedit), [gimp-help-fr](https://packages.debian.org/bullseye/gimp-help-fr), [cmatrix](https://packages.debian.org/bullseye/cmatrix), [gitg](https://packages.debian.org/bullseye/gitg) (git repository viewer), reduce number of default installed fonts
- extras: remove [xfce4-terminal-colorschemes](https://gitlab.com/nodiscc/xfce4-terminal-colorschemes)
- extras: remove custom [nano text editor syntax highlighting](https://github.com/scopatz/nanorc)
- remove custom grub configuration, revert to debian defaults
- remove [HTTPS everywhere](https://packages.debian.org/bullseye/webext-https-everywhere) firefox addon (replaced with built-in "HTTPS only" mode)

### Fixed

- apt: always install/upgrade Linux kernel and Nvidia drivers from [backports](https://backports.debian.org/)
- skel: fix default file associations for text and media files
- installer: fix unbootable system when selecting "whole disk with encrypted LVM" in debian installer disk partitioning options
- fix not working/partially working desktop session language selection

### Upgrade procedure

If you have a system installed from a previous version of `debian-live-config`:

- Recommended: [Backup](https://backintime.readthedocs.io/en/latest/) user data, [download](https://debian-live-config.readthedocs.io/en/latest/download-and-installation.html) the latest ISO image, reinstall (overwrite the existing installation), restore data from backups
- To upgrade without reinstalling:

```bash
# read Debian 11 release notes: https://www.debian.org/News/2021/20210814
# replace buster with bullseye in your APT sources
sudo sed -i 's/buster/bullseye/g' /etc/apt/sources.list /etc/apt/sources.list.d/*
# install the updated APT configuration
sudo rm -v /etc/apt/sources.list.d/debian-buster-updates-security-backports.list
wget https://gitlab.com/nodiscc/debian-live-config/-/blob/bullseye/config/archives/debian-updates-security-backports.list.chroot
sudo mv -v debian-updates-security-backports.list.chroot /etc/apt/sources.list.d/debian-updates-security-backports.list
# run the upgrade
sudo apt update && sudo apt dist-upgrade
# optionally, update your configuration according to changes since the last release:
# https://gitlab.com/nodiscc/debian-live-config/-/compare/2.2.5...3.0.0
# /etc/skel modifications will only take effect after creating a new user account
```

---------------------

## [v2.2.5](https://gitlab.com/nodiscc/dlc/releases/tag/2.2.5) - 2020-12-16

### Removed

- remove [Liferea](https://packages.debian.org/buster/liferea) feed reader from default install
- remove [gnome-maps](https://packages.debian.org/buster/gnome-maps) from default install

### Fixed

- nano: fix loading of syntax highlighting configuratio from ~/.nano/*.nanorc


### Changed

- update third-party Lutris package to 0.5.8.1
- update documentation/.gitconfig examples
- tools: improve build/cleanup mechanisms

-------------------------------

## [v2.2.4](https://gitlab.com/nodiscc/dlc/releases/tag/2.2.4) - 2020-10-22

### Added

- add [Lutris](https://lutris.net) gaming platform
- add sensible defaults for mousepad text editor

### Fixed

- fix display of virt-manager console (add missing  gir1.2-spiceclientgtk-3.0 package)


### Changed

- update all packages to latest version (Debian 10.6)
- replace ntp time synchronization service with [chrony](https://chrony.tuxfamily.org/)
- keyboard shortcuts: add ctrl+alt+shift+left/down/right/up to move current windows to the left/down/right/up workspace
- libvirt: set the default URI to qemu:///system (virsh now works without sudo or --connect)
- dotfiles/conky: don't draw shades by default
- update documentation
- tools: various Makefile improvements

-------------------------------

## [v2.2.3](https://gitlab.com/nodiscc/dlc/releases/tag/2.2.3) - 2020-05-10

Bugfix release.

### Fixed

- packages: add non-free nvidia-driver (fix no display at X startup on nvidia cards)
- packages: fix inability to mount luks encrypted disks (missing libblockdev-crypto2 package)
- packages: fix lightdm not showing the user list (missing accountsservice package)
- doc: fix readthedocs TOC/typos/syntax, reorder graphics package list, update auto-generated documentation (make doc), add links to source mirrors

### Changed

- dotfiles: .bash_aliases: add example of return code indication in bash prompt
- tools: remove unused build dependencies (xmlstarlet, shellcheck), add gnupg to build dependencies (checksums signing), add python3-venv to build dependencies (doc generation)

-------------------------------

## [v2.2.2](https://gitlab.com/nodiscc/debian-live-config/-/tags/2.2.2) - 2020-04-11

### Changed

- Disable window manager compositor by default (improve video performance/prevent tearing)
- Update [user.js](https://gitlab.com/nodiscc/user.js) to 0.1
- Remove unused locales from live system (only keep en/fr), decrease iso image size

### Added

- Documentation at https://debian-live-config.readthedocs.io/ (auto-generated with Sphinx/python script)

### Fixed

- Fix APT sources lists not present in the final image
- Improve/cleanup makefile and package lists
- Fix error during installation in EFI boot mode


-------------------------------


## [v2.2.1](https://gitlab.com/nodiscc/debian-live-config/-/tags/2.2.1) - 2020-03-14

### Changed

- remove all plymouth/wallpaper customizations, use Debian defaults
- display plymouth boot loading screen
- Makefile: move 3rd party downloads to separate file, improve 'clean' target, improve idempotence/separation of concerns
- skel: quodlibet: set default rating to 0
- skel: xfwm: decrease default number of workspaces to 2
- skel: xfwm4: disable window shadows
- update README

### Added

- add third party package for https://github.com/EionRobb/pidgin-opensteamworks/
- add third party download for https://addons.mozilla.org/en-US/firefox/addon/keepassxc-browser/
- add third party download for https://addons.mozilla.org/en-US/firefox/addon/cookie-autodelete/
- add third party download for https://gitlab.com/nodiscc/user.js
- add third-party download for https://github.com/az0/cleanerml
- add (disabled) third party download for  https://www.sublimetext.com/
- Makefile: add a target to generate a TODO.md from a list of gitea issues, add TODO.md

### Removed

- remove Samba server

### Fixed

- fix broken installation of graphics/image packages list
- associate SVG files with ristretto

-------------------------------

## [v2.2](https://gitlab.com/nodiscc/dlc/releases/tag/2.2) - 2020-03-08

Initial release, git repository reset and rebuilt from scratch. See commit messages and documentation.

<!--
### Changed
### Added
### Removed
### Fixed
### Security
### Deprecated
-->
