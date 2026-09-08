### Extras

Components that are not part of the official Debian distribution are listed in [Makefile.extra](https://codeberg.org/nodiscc/debian-live-config/src/branch/master/Makefile.extra):

<!-- grep "# EXTRA" Makefile.extra | grep -v "# DISABLED" -->

- <https://github.com/az0/cleanerml>
- <https://github.com/nodiscc/user.js>
- <https://addons.thunderbird.net/thunderbird/addon/gmail-conversation-view/>

These components are downloaded from a [third-party repository](http://nodiscc.gitlab.io/toolbox) or directly from their upstream project. You will not receive any updates for these packages unless you [enable the APT repository manually](https://codeberg.org/nodiscc/debian-live-config/src/branch/master/config/includes.chroot/etc/apt/sources.list.d/debian-live-config.list) or if an official package with the same name is someday [added to Debian repositories](https://wnpp.debian.net/).
