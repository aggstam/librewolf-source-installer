# librewolf-source-installer
A helper script extracting and installing a packaged [Liberwolf](https://librewolf.net/) source tar archive.
<br>
We are using [source](https://codeberg.org/librewolf/source) repo as a git submodule, but you can use this
script to extract from another path.

## Prerequisites
If you want to use the Librewolf source repo to build and package Librewolf yourself(the correct way),
you can use the `source` submodule folder.
<br>
On initial pull:
```
% git submodule update --init
```
To pull updates:
```
% git pull --recurse-submodules
```
Then, you can follow their [build](https://codeberg.org/librewolf/source#building-with-this-repository)
instructions.
### TLDR
#### Initial pull
```
% cd source
% make dir
% make bootstrap
```
#### Build and package
```
% cd source
% make build
% make package
```

## Usage
Script provides the following Make targets:
| Target         | Description                                |
|----------------|--------------------------------------------|
| `build-folder` | Generate build folder                      |
| `clean`        | Remove build artifacts                     |
| `extract`      | Extract configured/provided archive        |
| `install`      | Install extracted artifacts                |
| `desktop`      | Install .desktop file                      |
| `firejail`     | Install firejail configuration             |
| `uninstall`    | Remove installed artifacts from the system |

Based on the above table, the basic usage is:
```
% make extract install
```
After that, you can generate the corresponding .desktop file and/or firejail
configuration using:
```
% make desktop
% make firejail
```
Obviously you can combine them all together in a single command:
```
% make extract install desktop firejail
```
If you are using a different archive, you can pass it using `TAR={YOUR_TAR_PATH_HERE]`
build argument, like:
```
% make extract install TAR=tar_downloaded_from_sus_site_def_not_malicious.tar.bz2
```

## Notes
### Source folder
If you are using the source folder to build Librewolf, you should remove old packaged
versions, once you pulled and builded a newer one, to preserve your disk space.
### Firejail
A librewolf.local firejail configuration file is provided.
<br>
If the repo folder is not on home root folder (~/), you should update it to contain
the proper path.

## Credits
Massive thanks to the Librewolf team for making such an awesome browser!
<br>
Repo icon and .desktop file where directly copied from Librewolf assets.
