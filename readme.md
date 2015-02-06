# Arch Linux config

## Base
`base base-devel`

## Network
`iw wpa_suplicant dialog networkmanager`

## Xorg
`xorg xorg-xinit xorg-twm xorg-xclock xterm`

## Pacman
/etc/pacman.d/mirrorlist
```
Server = http://archlinux.polymorf.fr/$repo/os/$arch
Server = http://mir.archlinux.fr/$repo/os/$arch
```

/etc/pacman.conf
```
ILoveCandy

[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch
```

`yaourt`

/etc/yaourtrc
```
DIFFEDITCMD="meld"
```

## makepkg
/etc/makepkg.conf
```
PKGEXT='.pkg.tar'
COMPRESSXZ=(xz -T0 -c -z -)
```

## Tools
`git subversion mercurial htop bmon`

## SSH
.ssh/config
```
ControlMaster auto
ControlPath /tmp/%r@%h:%p
ControlPersist yes
```

## Font
`ttf-google-fonts-git`

## Gnome
`gnome gnome-extra gnome-tweak-tool`

`alacarte` | `menulibre`

https://extensions.gnome.org/extension/307/dash-to-dock

https://extensions.gnome.org/extension/495/topicons

## Shell
`zsh`

https://github.com/robbyrussell/oh-my-zsh

Plugins: `git history-substring-search`

$HOME/.zshrc
```
source $ZSH/oh-my-zsh.sh

ulimit -n 4096

export EDITOR=nano

alias drop-caches="sudo zsh -c 'sync;echo 3 > /proc/sys/vm/drop_caches'"

export PATH=$PATH:$HOME/Logiciels

export PATH=$PATH:$HOME/Logiciels/android-sdk/platform-tools
alias fix-adb="sudo zsh -c 'killall adb;/home/pierre/Logiciels/android-sdk/platform-tools/adb start-server'"
alias apktool="java -jar $HOME/Logiciels/apktool.jar"

my-services() {
    action=$1
    sudo systemctl $action elasticsearch
    sudo systemctl $action mongodb
    sudo systemctl $action httpd
    sudo systemctl $action memcached
    sudo systemctl $action redis
    sudo systemctl $action rabbitmq
    sudo systemctl $action haproxy
}

source $HOME/.gorc/gorc.sh
```

## Appearance
`zukitwo-themes faenza-icon-theme xcursor-human`

## Web
`google-chrome-dev firefox firefox-i18n-fr`

## Java
`jdk`

## Development
`smartgit atom-editor meld redis memcache`

## Go
https://go.googlesource.com => `$HOME/Logiciels/go`

https://github.com/visualfc/liteide => `$HOME/Git/visualfc/liteide`

https://github.com/pierrre/gorc => `$HOME/.gorc`

## Office
`libreoffice-fresh libreoffice-fresh-fr`
