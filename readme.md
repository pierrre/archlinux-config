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

## SSH
`openssh`

Service `sshd`

.ssh/config
```
ControlMaster auto
ControlPath /tmp/%r@%h:%p
ControlPersist yes
```

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

## Touchpad
Use libinuput instead of evdev

`xf86-input-synaptics`

## Bumblebee / Optimus / Nvidia
https://wiki.archlinux.org/index.php/bumblebee

`bumblebee mesa xf86-video-intel nvidia`

Service `bumblebeed`
`gpasswd -a user bumblebee`

Test with `mesa mesa-demos` => glxgears, glxspheres

For 32 bits apps `lib32-virtualgl lib32-nvidia-utils lib32-mesa-libgl`

## LightDM
https://wiki.archlinux.org/index.php/LightDM

`lightdm lightdm-gtk-greeter`

Enable autologin

## Xfce
`xfce4 xfce4-goodies`

`network-manager-applet gnome-keyring menulibre thunar-dropbox`

`gvfs gvfs-afc gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb`

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
			<glob>/usr/share/fonts/OTF/SyrCOM*</glob>
			<glob>/usr/share/fonts/OTF/GohaTibebZemen.otf</glob>
			<glob>/usr/share/fonts/TTF/GohaTibebZemen.ttf</glob>
			<glob>/usr/share/fonts/Type1</glob>
		</rejectfont>
	</selectfont>
</fontconfig>
```

## Appearance
`faenza-icon-theme zukitwo-themes`

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

export GIMME_GO_VERSION=1.6
export GIMME=$HOME/.gimme
export GIMME_TYPE=source
export GIMME_SILENT_ENV=1
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
	go get -v -d golang.org/x/tools
	go install -v golang.org/x/tools/cmd/benchcmp
	go install -v golang.org/x/tools/cmd/godoc
	go install -v golang.org/x/tools/cmd/goimports
	go install -v golang.org/x/tools/cmd/oracle
	go get -v -d github.com/golang/lint
	go install -v github.com/golang/lint/golint
	go get -v -d github.com/nsf/gocode
	go install -v github.com/nsf/gocode
	go get -v -d github.com/rogpeppe/godef
	go install -v github.com/rogpeppe/godef
	go get -v -d github.com/tools/godep
	go install -v github.com/tools/godep
	go get -v -d github.com/pierrre/gotestcover
	go install -v github.com/pierrre/gotestcover
	go get -v -d github.com/pierrre/hfs
	go install -v github.com/pierrre/hfs
}

export PATH=$PATH:$HOME/Logiciels/android-sdk/platform-tools
alias adb-screencap="adb exec-out screencap -p"
alias fix-adb="sudo zsh -c 'killall adb;/home/pierre/Logiciels/android-sdk/platform-tools/adb start-server'"
alias apktool="java -jar $HOME/Logiciels/apktool.jar"
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

## Laptop LID switch
/etc/systemd/logind.conf
```
HandleLidSwitch=ignore
```
