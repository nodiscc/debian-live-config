
### Extras

For convenience, some software that are not part of the official Debian distribution is included in the live system/installer. These components are listed in [Makefile.extra](https://gitlab.com/nodiscc/debian-live-config/-/blob/master/Makefile.extra):

<!-- grep '# EXTRA' Makefile.extra -->

 - https://github.com/az0/cleanerml
 - https://github.com/nodiscc/user.js
 - https://github.com/EionRobb/pidgin-opensteamworks/
 - https://github.com/yt-dlp/yt-dlp
 - https://addons.mozilla.org/en-US/firefox/addon/keepassxc-browser/
 - https://addons.mozilla.org/en-US/firefox/addon/cookie-autodelete/

These components installed from a [third-party APT repository](http://nodiscc.gitlab.io/toolbox), you will not receive any updates for this packages unless you [enable the APT repository manually](https://gitlab.com/nodiscc/debian-live-config/-/blob/bullseye/config/includes.chroot/etc/apt/sources.list.d/debian-live-config.list= or) someone [packages and uploads newer versions](https://wnpp.debian.net/) to official Debian repositories.
