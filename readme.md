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
Host github.com
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
