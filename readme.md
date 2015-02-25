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

## SSH
.ssh/config
```
ControlMaster auto
ControlPath /tmp/%r@%h:%p
ControlPersist yes
```

## Shell
`zsh`

https://github.com/robbyrussell/oh-my-zsh

Plugins: `git git-extras screen colored-man history-substring-search golang composer symfony2`

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

## Bumblebee / Optimus / Nvidia shit
https://wiki.archlinux.org/index.php/bumblebee

## Font
`ttf-dejavu ttf-google-fonts-git ttf-mac-fonts ttf-ms-fonts`

## Gnome
`gnome gnome-extra gnome-tweak-tool`

`alacarte` | `menulibre`

Extensions:
- https://extensions.gnome.org/extension/307/dash-to-dock
- https://extensions.gnome.org/extension/495/topicons
- Applications menu
- Native window placement
- User themes

## Appearance
`zukitwo-themes faenza-icon-theme xcursor-human`

## Tools
`git subversion mercurial htop bmon nethogs iotop ntp openssh meld jq parallel speedtest-cli wkhtmltopdf youtube-dl graphicsmagick imagemagick gource screen`

## Web
`google-chrome-dev firefox firefox-i18n-fr`

## Java
`jdk`

## Development
`smartgit phpstorm memcached nodejs mongodb ruby`

## Elasticsearch
`elasticsearch`

/etc/elasticsearch/elasticsearch.yml
```
script.disable_dynamic: false
script.groovy.sandbox.enabled: false

http.compression: true
http.compression_level: 9
```

## RabbitMQ
`rabbitmq`

`rabbitmq-plugins enable rabbitmq_management`

## Redis
`redis`

/etc/redis.conf
```
# save 900 1
# save 300 10
# save 60 10000
```

## Go
https://go.googlesource.com => `$HOME/Logiciels/go`

https://github.com/pierrre/gorc => `$HOME/.gorc`

https://github.com/visualfc/liteide => `$HOME/Git/visualfc/liteide`

LiteIDE requires `qt5 qt qtwebkit`.

## Atom
`atom-editor`

`apm stars --user pierrre --install`

## Apache
`apache`

## PHP
`php php-pear php-apache php-gd php-intl php-mcrypt php-mongo php-tidy xdebug`

PECL packages:
- imagick

https://wiki.archlinux.org/index.php/Apache_HTTP_Server

## HAProxy
`haproxy`

/etc/haproxy/haproxy.cfg
```
global
    ssl-default-bind-options no-sslv3

frontend https
    bind 127.0.0.1:443 ssl crt /etc/ssl/certs/MYCERT.pem

    reqadd X-Forwarded-Proto:\ https if { dst_port 443 }
    reqadd X-Forwarded-Port:\ 443 if { dst_port 443 }

    use_backend stats if { hdr_dom(host) -i local-haproxy }

    default_backend apache

backend apache
    server apache 127.0.0.1:80

backend stats
    stats enable
    stats uri /
```

## Office
`libreoffice-fresh libreoffice-fresh-fr`

## Dropbox
`dropbox nautilus-dropbox`

## VirtualBox
`virtualbox virtualbox-host-dkms virtualbox-host-modules virtualbox-ext-oracle`

## Steam
`steam`

## Gimp
`gimp`

## Printer
`cups hplip`

## Autostart services
- NetworkManager
- gdm
- bumblebeed
- dkms
- ntpd
- sshd
- org.cups.cupsd
