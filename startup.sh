#!/bin/bash

sudo apt update -y
sudo apt dist-upgrade -y 
sudo apt install -y gawk wget git diffstat unzip texinfo gcc build-essential chrpath \
	socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping \
	python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev python3-subunit \
	mesa-common-dev zstd liblz4-tool file locales curl tmux tftpd-hpa \
	nfs-kernel-server

curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
sudo dpkg -i ripgrep_13.0.0_amd64.deb

git config --global user.name "harrisonw"
git config --global user.email "harrisonw@bytesnap.co.uk"

sudo mkdir -p /srv/tftp
sudo mkdir -p /srv/nfs

printf 'TFTP_USERNAME="tftp" \nTFTP_DIRECTORY="/srv/tftp" \nTFTP_ADDRESS="0.0.0.0:69" \nTFTP_OPTIONS="--secure"' > /etc/default/tftpd-hpa
printf '/srv/nfs *(rw,no_root_squash,async,no_subtree_check)' > /etc/exports

sudo service tftpd-hpa restart
sudo service nfs-kernel-server restart

if [ ! -f /usr/bin/nvim ]; then
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
	chmod u+x nvim.appimage
	./nvim.appimage --appimage-extract
	./squashfs-root/AppRun --version
	sudo mv squashfs-root /
	sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
	echo 'alias vi="nvim"' >> ~/.bashrc
fi

cp -r ~/vm_setup/nvim ~/.config/
cp -r ~/vm_setup/.tmux.conf ~/.tmux.conf
rm -rf ~/.tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

if [ ! -f ~/bin/repo ]; then
	 mkdir -p ~/bin
	 curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
	 chmod a+x ~/bin/repo
	echo "export PATH=~/bin:$PATH" >> ~/.bashrc
fi

sudo snap install universal-update-utility
sudo snap connect universal-update-utility:removable-media
sudo sh -c "uuu -udev >> /etc/udev/rules.d/70-uuu.rules"
sudo udevadm control --reload
