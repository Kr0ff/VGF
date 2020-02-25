#!/bin/bash

GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
CYAN="\e[36m"
RESET="\e[00m"

ART="
__________________
|.----------------.|
||                ||
||    ScR33nY     ||
||   ----------   ||
||    VMware      ||
||                ||
||__________|  |__||
'-----------|__r--'
"

printf "${CYAN}${ART}${RESET}\n"
printf "${YELLOW}[!] The script requires root permissions to enable and start the services !${RESET}\n"
printf "${YELLOW}[*] Please enter sudo password when asked...${RESET}\n"
sleep 1
if ! [ -x "$(which vmware-user-suid-wrapper)" ]; then
	printf "${RED}[-] 'open-vm-tools' are not installed !${RESET}\n" >&2
	printf "${YELLOW}[*] Please install the package by using your distro's package manager${RESET}\n" >&2
	exit 1
else
	printf "${GREEN}[+] Service 'vmtoolsd' will be enabled and started !${RESET}\n"
    if ! [ -x "$(sudo systemctl enable vmtoolsd.service; sudo systemctl start vmtoolsd.service)"]; then
        printf "${RED}[-] Service 'vmtoolsd' does not exist !${RESET}\n"
        printf "${YELLOW}[!]Are you sure 'open-vm-tools is installed ?${RESET}\n"
        exit 1
    fi
	sleep 1.5
	printf "${GREEN}[+] Service 'vmware-vmblock-fuse' will be enabled and started !${RESET}\n"
	if ! [ -x "$(sudo systemctl enable vmware-vmblock-fuse.service; sudo systemctl start vmware-vmblock-fuse.service)"]; then
        printf "${RED}[-] Service 'vmware-vmblock-fuse' does not exist !${RESET}\n"
        printf "${YELLOW}[!]Are you sure 'open-vm-tools is installed ?${RESET}\n"
        exit 1
    fi
	sleep 1.5
	printf "${GREEN}[+] Adding 'vmware-user-suid-wrapper' to i3 config to enable copy/paste !${RESET}"
    if [ "$(ls $HOME/.config/i3/ | grep "config" | head -n 1 )" = "config" ]; then
        echo "bindsym exec vmware-user-suid-wrapper --no-startup-id" >> $HOME/.config/i3/config
    else
        printf "${RED}[-] Cannot find i3 config, please check where your config file is placed and edit the script !${RESET}\n"
        exit 1
    fi
fi
printf "\n${YELLOW}[!] Hopefully, all is set now :)${RESET}\n"
exit 0
