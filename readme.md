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

## Font
`adobe-source-*-fonts`

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
		<edit name="lcdfilter" mode="assign">
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
			<glob>/usr/share/fonts/cantarell</glob>
			<glob>/usr/share/fonts/gsfonts</glob>
			<glob>/usr/share/fonts/misc</glob>
			<glob>/usr/share/fonts/OTF/GohaTibebZemen.otf</glob>
			<glob>/usr/share/fonts/OTF/SyrCOM*</glob>
			<!-- <glob>/usr/share/fonts/TTF/DejaVu*</glob> -->
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

## GUI Tools
`meld baobab`

## Web
`google-chrome-dev firefox firefox-i18n-fr`

## Development
`smartgit`

## Printer
`system-config-printer cups`

Service `org.cups.cupsd`

`hplip`

## Laptop LID switch
/etc/systemd/logind.conf
```
HandleLidSwitch=ignore
```
