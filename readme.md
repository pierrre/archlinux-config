# Arch Linux config

## Base
`base base-devel`

## Network
`iw wpa_supplicant dialog wpa_actiond networkmanager`

## Bumblebee / Optimus / Nvidia shit
https://wiki.archlinux.org/index.php/bumblebee

Service `bumblebeed`

## Xorg
`xorg-xinit xorg-twm xorg-xclock xterm`

/etc/X11/xorg.conf.d/10-keyboard.conf
```
Section "InputClass"
	Identifier "system-keyboard"
	MatchIsKeyboard "on"
	Option "XkbLayout" "fr"
	Option "XkbVariant" "latin9"
EndSection
```

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
`openssh`

Service `sshd`

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
```sh
source $ZSH/oh-my-zsh.sh

ulimit -n 4096

export EDITOR=nano
export PATH=$PATH:$HOME/Logiciels
export CDPATH=.:$HOME

export GIMME_GO_VERSION=1.5.1
export GO15VENDOREXPERIMENT=1
source $HOME/.gorc/gorc.sh

export PATH=$PATH:$HOME/Logiciels/android-sdk/platform-tools
alias adb-screencap="adb exec-out screencap -p"
alias fix-adb="sudo zsh -c 'killall adb;/home/pierre/Logiciels/android-sdk/platform-tools/adb start-server'"
alias apktool="java -jar $HOME/Logiciels/apktool.jar"

alias drop-caches="sudo zsh -c 'sync;echo 3 > /proc/sys/vm/drop_caches'"
alias clean-swap="sudo zsh -c 'swapoff -a && swapon -a'"

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
```

## Font
`adobe-source-sans-pro-fonts adobe-source-code-pro-fonts adobe-source-serif-pro-fonts`

~/.config/fontconfig/fonts.conf
```xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
	<!-- improve rendering -->
	<match target="font">
		<edit name="antialias" mode="assign">
			<bool>true</bool>
		</edit>
		<edit name="hinting" mode="assign">
			<bool>true</bool>
		</edit>
		<edit name="hintstyle" mode="assign">
			<const>hintslight</const>
		</edit>
		<edit name="rgba" mode="assign">
			<const>rgb</const>
		</edit>
		<edit mode="assign" name="lcdfilter">
			<const>lcddefault</const>
		</edit>
		<edit name="embeddedbitmap" mode="assign">
			<bool>false</bool>
		</edit>
	</match>

	<!-- prefer -->
	<alias>
		<family>sans-serif</family>
		<prefer>
			<family>Source Sans pro</family>
		</prefer>
	</alias>
	<alias>
		<family>serif</family>
		<prefer>
			<family>Source Serif pro</family>
		</prefer>
	</alias>
	<alias>
		<family>monospace</family>
		<prefer>
			<family>Source Code pro</family>
		</prefer>
	</alias>

	<!-- disable -->
	<selectfont>
		<rejectfont>
			<glob>/usr/share/fonts/misc</glob>
			<glob>/usr/share/fonts/OTF/SyrCOM*</glob>
			<glob>/usr/share/fonts/OTF/GohaTibebZemen.otf</glob>
			<glob>/usr/share/fonts/TTF/GohaTibebZemen.ttf</glob>
			<glob>/usr/share/fonts/Type1</glob>
		</rejectfont>
	</selectfont>
</fontconfig>
```

## Xfce
`xfce4 xfce4-goodies lightdm lightdm-gtk-greeter`

/etc/lightdm/lightdm.conf
```
greeter-session=lightdm-gtk-greeter
```

Lock

`gnome-screensaver light-locker`

Gnome tools

`evince file-roller baobab`

## gvfs
`gvfs gvfs-afc gvfs-gphoto2 gvfs-mtp gvfs-smb`

## Appearance
`zukitwo-themes faenza-icon-theme`

## Tools
`wget git subversion mercurial htop bmon nethogs iotop meld jq parallel speedtest-cli wkhtmltopdf youtube-dl graphicsmagick imagemagick gource screen unzip menulibre`

## Web
`google-chrome-dev firefox firefox-i18n-fr`

## Java
`jdk`

## Development
`smartgit phpstorm memcached nodejs mongodb ruby`

## Elasticsearch
`elasticsearch`

/etc/elasticsearch/elasticsearch.yml
```yaml
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
https://github.com/pierrre/gorc => `$HOME/.gorc`

`intellij-idea-community-edition`

https://github.com/go-lang-plugin-org/go-lang-idea-plugin

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
`dropbox thunar-dropbox`

## VirtualBox
`virtualbox virtualbox-host-dkms virtualbox-host-modules virtualbox-ext-oracle`

## Steam
`steam`

## Gimp
`gimp`

## Printer
`system-config-printer cups hplip`

Service `org.cups.cupsd`

## Autostart services
- NetworkManager
- systemd-timesyncd
- gdm | lightdm
- dkms

## Swappiness
/etc/sysctl.d/99-sysctl.conf
```
vm.swappiness=10
```

## Laptop LID switch
/etc/systemd/logind.conf
```
HandleLidSwitch=ignore
```
