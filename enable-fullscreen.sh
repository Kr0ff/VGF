#!/bin/bash

GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[00m"


if ! [ -x "$(which vmware-user-suid-wrapper)" ]; then
	printf "${RED}[-] 'open-vm-tools' are not installed !${RESET}" >&2
	printf "${YELLOW}[*] Please install the package by using your distro's package manager${RESET}" >&2
	exit 1
else	
	
	printf "${GREEN}[+] Service 'vmtoolsd' will be enabled and started !${RESET}"
	sudo systemctl enable vmtoolsd.service && sudo systemctl start vmtoolsd.service
	sleep 1.5
	printf "${GREEN}[+] Service 'vmware-vmblock-fuse' will be enabled and started !${RESET}"
	sudo systemctl enable vmware-vmblock-fuse.service && sudo systemctl start vmware-vmblock-fuse.service
	sleep 1.5
	printf "${GREEN}[+] Adding 'vmware-user-suid-wrapper' to i3 config to enable copy/paste !${RESET}"
	echo -n "bindsym exec vmware-user-suid-wrapper --no-startup-id > $HOME/.config/i3/config"
	
fi

printf "${YELLOW}[+] Hopefully all is set now :)${RESET}"
exit 0
