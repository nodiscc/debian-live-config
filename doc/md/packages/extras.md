
### Extras

For convenience, some software that are not part of the official Debian distribution is included in the live system/installer. These components are listed in [Makefile.extra](https://gitlab.com/nodiscc/debian-live-config/-/blob/master/Makefile.extra):

<!-- grep '# EXTRA' Makefile.extra -->

 - https://github.com/scopatz/nanorc
 - https://github.com/az0/cleanerml
 - https://github.com/nodiscc/user.js
 - https://github.com/EionRobb/pidgin-opensteamworks/
 - https://github.com/yt-dlp/yt-dlp
 - https://addons.mozilla.org/en-US/firefox/addon/keepassxc-browser/
 - https://addons.mozilla.org/en-US/firefox/addon/cookie-autodelete/

These components are not installed from APT repositories and will receive no automatic updates unless someone [packages and uploads them](https://wnpp.debian.net/) to the Debian archive. Please refer to each component's documentation for manual upgrade instructions.
