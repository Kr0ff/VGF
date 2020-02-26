#!/bin/bash

####TO DO#####
#This has been tested only on ArchLinux and ArcoLinux, please update the script with your i3 config location :)
#I will work on it to integrate it with more distros and to auto check what distro is running...
##############


GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
CYAN="\e[36m"
LBLUE="\e[94m"
LGREEN="\e[92m"
RESET="\e[00m"

#USER_INPUT=""

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

function check {
    printf "${YELLOW}[!] The script requires root permissions to enable and start the services !${RESET}\n"
    printf "${YELLOW}[*] Please enter sudo password when asked...${RESET}\n"
    sleep 1
    if ! [ -x "$(which vmware-user-suid-wrapper 2>/dev/null)" ]; then
	    printf "${RED}[-] 'open-vm-tools' are not installed !${RESET}\n" >&2
	    #printf "${YELLOW}[*] Please install the package by using your distro's package manager${RESET}\n" >&2
        sleep 1
        printf "${LBLUE}[?] Would you like to install 'open-vm-tools' ? [y/n]${RESET} "
        read USER_INPUT
        if [ ${USER_INPUT} = "y" ]  || [ ${USER_INPUT} = "Y" ]; then
            printf "${YELLOW}[!] Now running pacman to install 'open-vm-tools' package...${RESET}\n "
            sudo pacman -Sy open-vm-tools --noconfirm
            printf "\n"
            start_services
        elif [ ${USER_INPUT} = "n" ] || [ ${USER_INPUT} = "N" ]; then
            printf "${RED}[-] CYAAAA... !${RESET}\n"
            exit 1
        else
            exit 1
        fi
    else
        printf "${GREEN}[+] Package 'open-vm-tools' is already installed !${RESET}\n"
        start_services
    fi
}

function start_services {
    printf "${LGREEN}[*] Now going to start all services required...${RESET}\n"
    sleep 1.2
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
	printf "${GREEN}[+] Adding 'vmware-user-suid-wrapper' to i3 config to enable copy/paste !${RESET}\n"
    if [ "$(ls $HOME/.config/i3/ | grep "config" | head -n 1 )" = "config" ]; then
        echo "exec vmware-user-suid-wrapper --no-startup-id" >> $HOME/.config/i3/config
    else
        printf "${RED}[-] Cannot find i3 config, please check where your config file is placed and edit the script !${RESET}\n"
        exit 1
    fi
}
check
printf "\n${YELLOW}[!] Hopefully, all is set now :)${RESET}\n"
exit 0
