# Gbyzanz

[![License](https://img.shields.io/badge/license-GPLv3%2B-blue.svg)](http://www.gnu.org/licenses/gpl.html)

Gbyzanz is a GUI front-end for byzanz which develop by QML.It is bower by [GNOME/byzanz](https://github.com/GNOME/byzanz) and [qml-material](https://github.com/papyros/qml-material).It only test on deepin OS.

##Dependencies

- Qt 5.4 or higher.
- [qml-material](https://github.com/papyros/qml-material)

## Build

- `$git clone https://github.com/Match-Yang/Gbyzanz.git`
- `$tar -zcf gbyzanz_0.1.orig.tar.gz Gbyzanz`
- `$cd Gbyzanz/`
- `$dpkg-buildpackage (you should install all the packages depend by dpkg-buildpackage)`

## Install
- `$sudo dpkg -i gbyzanz_0.1-1_amd64.deb`

##Licensing

Gbyzanz is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.