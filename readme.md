# Arch Linux config

## Base
`base base-devel`

## LTS
`linux-lts`

## Network
`iw wpa_supplicant dialog networkmanager`

Service `NetworkManager` (after installing GUI)

## Microcode
https://wiki.archlinux.org/index.php/microcode

`intel-ucode`

## Bootloader
https://wiki.archlinux.org/index.php/Systemd-boot

/boot/loader/loader.conf
```
default		arch
timeout		0
```

/boot/loader/entries/arch.conf
```
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options root=LABEL=root rw
```

Do an LTS entry.

## Swappiness
/etc/sysctl.d/99-sysctl.conf
```
vm.swappiness=10
```

## Max user watches
/etc/sysctl.d/99-sysctl.conf
```
fs.inotify.max_user_watches=524288
```

## Useful services
Service `systemd-timesyncd`

`haveged` +service

## Tools
`zsh`

`wget`

`git subversion mercurial`

`htop bmon nethogs iotop`

`parallel unzip`

`jq`

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

## Yay
https://github.com/Jguer/yay

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

## Keyboard X11
/etc/X11/xorg.conf.d/00-keyboard.conf

```
Section "InputClass"
	Identifier "system-keyboard"
	MatchIsKeyboard "on"
	Option "XkbLayout" "fr"
	Option "XkbVariant" "latin9"
EndSection
```

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
`meld baobab menulibre`

## Web
`google-chrome chrome-gnome-shell`

## Development
`smartgit`

`visual-studio-code-bin`

`docker docker-compose`
```
sudo gpasswd -a USER docker
```

## Printer
`system-config-printer cups`

Service `org.cups.cupsd`

`hplip`

## Laptop LID switch
/etc/systemd/logind.conf
```
HandleLidSwitch=ignore
```

## Bluetooth
Service `bluetooth`

https://wiki.archlinux.org/index.php/Bluetooth_headset#Connecting_works.2C_but_I_cannot_play_sound
```
mkdir -p  /var/lib/gdm/.config/systemd/user
ln -s /dev/null  /var/lib/gdm/.config/systemd/user/pulseaudio.socket
```

## NTFS
`ntfs-3g`
