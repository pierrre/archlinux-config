# Arch Linux config

## Base
`base base-devel`

## Network
`iw wpa_supplicant dialog networkmanager`

Service `NetworkManager` (after installing GUI)

## Microcode
https://wiki.archlinux.org/index.php/microcode

`intel-ucode`

## Swappiness
/etc/sysctl.d/99-sysctl.conf
```
vm.swappiness=10
```

## Useful services
Service `systemd-timesyncd`

`haveged` +service

## Tools
`wget`

`git subversion mercurial`

`htop bmon nethogs iotop`

`parallel unzip`

`speedtest-cli youtube-dl`

`graphicsmagick`

## Pacman
/etc/pacman.d/mirrorlist
```
Server = https://fooo.biz/archlinux/$repo/os/$arch
Server = http://archlinux.polymorf.fr/$repo/os/$arch
Server = http://mir.archlinux.fr/$repo/os/$arch
```

/etc/pacman.conf
```
ILoveCandy
```

Enable multilib

## Yaourt
https://archlinux.fr/yaourt

/etc/yaourtrc
```
DIFFEDITCMD="meld"
```

/etc/makepkg.conf
```
PKGEXT='.pkg.tar'
```
Speeds up package build

## Account
```
useradd -m -G wheel -s /bin/zsh USER
passwd USER
```

/etc/sudoers
```
%wheel ALL=(ALL) ALL

Defaults pwfeedback
```

## SSH
`openssh`

Service `sshd`

.ssh/config
```
ControlMaster auto
ControlPath /tmp/%r@%h:%p
ControlPersist 5m
```

## Touchpad
Use libinuput instead of evdev

`xf86-input-synaptics`

## Bumblebee / Optimus / Nvidia
https://wiki.archlinux.org/index.php/bumblebee

`bumblebee mesa xf86-video-intel nvidia`

Service `bumblebeed`
`gpasswd -a USER bumblebee`

Test with `mesa mesa-demos` => glxgears, glxspheres

For 32 bits apps `lib32-virtualgl lib32-nvidia-utils lib32-mesa-libgl`

## Gnome
`gnome gnome-extra`

Service `gdm`

## LightDM
https://wiki.archlinux.org/index.php/LightDM

`lightdm lightdm-gtk-greeter`

## Xfce
`xfce4 xfce4-goodies`

`network-manager-applet gnome-keyring seahorse menulibre thunar-dropbox`

`gvfs gvfs-afc gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb`

## Xorg
/etc/X11/xorg.conf.d/10-keyboard.conf
```
Section "InputClass"
	Identifier "system-keyboard"
	MatchIsKeyboard "on"
	Option "XkbLayout" "fr"
	Option "XkbVariant" "latin9"
EndSection
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
			<family>Source Sans Pro</family>
		</prefer>
	</alias>
	<alias>
		<family>serif</family>
		<prefer>
			<family>Source Serif Pro</family>
		</prefer>
	</alias>
	<alias>
		<family>monospace</family>
		<prefer>
			<family>Source Code Pro</family>
		</prefer>
	</alias>

	<!-- disable -->
	<selectfont>
		<rejectfont>
			<glob>/usr/share/fonts/misc</glob>
			<glob>/usr/share/fonts/OTF/C059*</glob>
			<glob>/usr/share/fonts/OTF/D050000L.otf</glob>
			<glob>/usr/share/fonts/OTF/GohaTibebZemen.otf</glob>
			<glob>/usr/share/fonts/OTF/Nimbus*</glob>
			<glob>/usr/share/fonts/OTF/P052*</glob>
			<glob>/usr/share/fonts/OTF/StandardSymbolsPS.otf</glob>
			<glob>/usr/share/fonts/OTF/SyrCOM*</glob>
			<glob>/usr/share/fonts/OTF/URW*</glob>
			<glob>/usr/share/fonts/OTF/Z003-MediumItalic.otf</glob>
			<glob>/usr/share/fonts/TTF/GohaTibebZemen.ttf</glob>
			<glob>/usr/share/fonts/Type1</glob>
		</rejectfont>
	</selectfont>
</fontconfig>
```

## Appearance
`faenza-icon-theme arc-gtk-theme`

## Shell
`zsh`

https://github.com/robbyrussell/oh-my-zsh

Plugins: `git git-extras colored-man history-substring-search golang`

$HOME/.zshrc
```sh
ulimit -n 4096

export EDITOR=nano
export PATH=$PATH:$HOME/Logiciels
export CDPATH=.:$HOME

alias drop-caches="sudo zsh -c 'sync;echo 3 > /proc/sys/vm/drop_caches'"
alias clean-swap="sudo zsh -c 'swapoff -a && swapon -a'"

GITHUB_TOKEN=xxx
git-clone-organization() {
	org=$1
	if [ -z "$org" ]; then
		echo "no organization argument"
		return 1
	fi
	urls=""
	page=1
	while true
	do
		json=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/orgs/$org/repos?page=$page&per_page=100")
		tmp=$(echo $json | jq -r '.[].ssh_url')
		if [ -z "$tmp" ]; then
			break
		fi
		if [ "$page" -ne 1 ]; then
			urls+=\\n
		fi
		urls+=$tmp
		page=$((page+1))
	done
	echo $urls | parallel -v -j 16 git clone {}
}
git-pull-dir() {
	dir=$1
	if [ -z "$dir" ]; then
		dir="."
	fi
	find $dir -mindepth 1 -maxdepth 1 -type d | parallel -v -j 16 git -C {} pull
}

export GIMME_GO_VERSION=1.7.4
export GIMME=$HOME/.gimme
export GIMME_TYPE=source
export GIMME_SILENT_ENV=1
export GIMME_DEBUG=1
export PATH=$PATH:$GIMME/bin
export GIMME_ENV=$GIMME/envs/go$GIMME_GO_VERSION.env
if [ -f "$GIMME_ENV" ]; then
	source $GIMME_ENV
fi
gimme-update() {
	mkdir -p $GIMME/bin
	curl -o $GIMME/bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
	chmod u+x $GIMME/bin/gimme
}
export GOPATH=$HOME/Go
export PATH=$PATH:$GOPATH/bin
export CDPATH=$CDPATH:$GOPATH/src:$GOPATH/src/github.com/pierrre
gopath-update() {
	go get -v -d -u -f .../
	gopath-refresh
}
gopath-refresh() {
	rm -rf $GOPATH/bin $GOPATH/pkg
	go get -v golang.org/x/tools/cmd/benchcmp
	go get -v github.com/tools/godep
	go get -v github.com/rakyll/hey
}

export PATH=$PATH:$HOME/Logiciels/android-sdk/platform-tools
alias adb-screencap="adb exec-out screencap -p"
alias fix-adb="sudo zsh -c 'killall adb;/home/pierre/Logiciels/android-sdk/platform-tools/adb start-server'"
alias apktool="java -jar $HOME/Logiciels/apktool.jar"

alias start-docker="sudo systemctl start docker"
alias start-mongo="docker pull mongo; docker container run --rm --detach --net=host --name=mongo mongo"
alias start-rabbitmq="docker pull rabbitmq:management-alpine; docker container run --rm --detach --net=host --name=rabbitmq rabbitmq:management-alpine"
alias start-redis="docker pull redis:alpine; docker container run --rm --detach --net=host --name=redis redis:alpine"
```

## GUI Tools
`meld baobab`

## Web
`google-chrome-dev firefox firefox-i18n-fr`

## Java
`jdk`

## Development
`smartgit phpstorm`

## Atom
`atom-editor`

`apm stars --user pierrre --install`

Gometalinter arguments:
```
--vendor, --disable-all, --enable=golint, --enable=vet, --enable=gosimple, --enable=ineffassign, --enable=deadcode, --tests, --json, --deadline=30s, .
```

## Office
`libreoffice-fresh libreoffice-fresh-fr`

## Dropbox
`dropbox`

## Gimp
`gimp`

## Printer
`system-config-printer cups`

Service `org.cups.cupsd`

`hplip`

## Redshift
https://wiki.archlinux.org/index.php/Redshift

`redshift`

~/.config/redshift.conf
```
[redshift]
temp-day=6500
temp-night=3400
transition=1
brightness-day=1
brightness-night=0.5
location-provider=manual
adjustment-method=randr

[manual]
lat=48.86
lon=2.35
```

## Laptop LID switch
/etc/systemd/logind.conf
```
HandleLidSwitch=ignore
```
