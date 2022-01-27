#!/bin/bash

GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
CYAN="\e[36m"
LBLUE="\e[94m"
LGREEN="\e[92m"
LPURPLE="\e[1;35m"
RESET="\e[00m"

ART="
=============================================
VGF - Get fullscreen working on your guest VM
=============================================
@Kr0ff
"
printf "${CYAN}${ART}${RESET}\n"

function kalilinux {
    printf "${YELLOW}[!]${RESET} Now running pacman to install 'open-vm-tools' package\n "
    sudo apt update && sudo apt install open-vm-tools -y
    printf "\n"
    start_services
}

function archlinux {
    printf "${YELLOW}[!]${RESET} Now running pacman to install 'open-vm-tools' package\n "
    sudo pacman -Syu open-vm-tools --noconfirm
    printf "\n"
    start_services
}

function fedora {
    printf "${YELLOW}[!]${RESET} Now running pacman to install 'open-vm-tools' package\n "
    sudo dnf update && sudo dnf -y install open-vm-tools
    printf "\n"
    start_services
}

function ubuntu {
    printf "${YELLOW}[!]${RESET} Now running pacman to install 'open-vm-tools' package\n "
    sudo apt update && sudo apt install open-vm-tools -y
    printf "\n"
    start_services
}

function parrotsec {
    printf "${YELLOW}[!]${RESET} Now running pacman to install 'open-vm-tools' package\n "
    sudo apt update && sudo apt install open-vm-tools -y
    printf "\n"
    start_services
}

function check_vmtools {
    printf "${YELLOW}The script requires root permissions to enable and start the services${RESET}\n\n"
    printf "${LBLUE}[*]${RESET} Please enter sudo password when asked\n"
    sleep 1
    if ! [ -x "$(which vmware-user-suid-wrapper 2>/dev/null)" ]; then
            printf "${RED}[-]${RESET} 'open-vm-tools' is not installed\n" >&2
        sleep 1
        printf "${LPURPLE}[?]${RESET} Would you like to install 'open-vm-tools' ? [Y/n] "
        read USER_INPUT
        if [[ (${USER_INPUT} = "") || (${USER_INPUT} = "y") || (${USER_INPUT} = "Y") ]]; then
            check_distro
        elif [[ (${USER_INPUT} = "n") || (${USER_INPUT} = "N") ]]; then
            printf "${RED}[-]${RESET} CYAAAA... !\n"
            exit 1
        else
            exit 1
        fi
    else
        printf "${GREEN}[+] Package 'open-vm-tools' is already installed !${RESET}\n"
        start_services
    fi
}

function check_distro {
        KALI="`cat /etc/os-release | grep -o 'kali' | head -n 1`"
        FEDORA="`cat /etc/os-release | grep -o 'fedora' | head -n 1`"
        ARCHLINUX="`cat /etc/os-release | grep -o 'arch' | head -n 1`"
        UBUNTU="`cat /etc/os-release | grep -o 'ubuntu' | head -n 1`"
        PARROTSEC="`cat /etc/os-release | grep -o 'Parrot OS' | head -n 1`"

        printf "${LBLUE}[*]${RESET} Checking distribution\n"
        if [[ ${KALI} ]]; then
                printf "${LGREEN}[+]${RESET} Distribution is ${LBLUE}Kali linux${RESET}\n"
                kalilinux
        elif [[ ${FEDORA} ]]; then
                printf "${LGREEN}[+]${RESET} Distribution is ${LBLUE}Fedora${RESET}\n"
                fedora
        elif [[ ${ARCHLINUX} ]]; then
                printf "${LGREEN}[+]${RESET} Distribution is ${LBLUE}Arch Linux${RESET}\n"
                archlinux
        elif [[ ${UBUNTU} ]]; then
                printf "${LGREEN}[+]${RESET} Distribution is ${LBLUE}Ubuntu${RESET}\n"
                ubuntu
        elif [[ ${PARROTSEC} ]]; then
                printf "${LGREEN}[+]${RESET} Distribution is ${LBLUE}ParrotSec${RESET}\n"
                parrotsec
        fi
}

function start_services {
    printf "${LBLUE}[*]${RESET} Now going to start all services required\n"
    sleep 1
    printf "${GREEN}[+]${RESET} Service 'vmtoolsd' will be enabled and started\n"
    if ! [ -x "$(sudo systemctl enable vmtoolsd.service; sudo systemctl start vmtoolsd.service)"]; then
        printf "${RED}[-]${RESET} Service 'vmtoolsd' does not exist\n"
        printf "${YELLOW}[!]${RESET} Check if 'open-vm-tools is installed\n"
        exit 1
    fi
        sleep 1
        printf "${GREEN}[+]${RESET} Service 'vmware-vmblock-fuse' will be enabled and started\n"
        
        if ! [ -x "$(sudo systemctl enable vmware-vmblock-fuse.service; sudo systemctl start vmware-vmblock-fuse.service)"]; then
        printf "${RED}[-]${RESET} Service 'vmware-vmblock-fuse' does not exist !\n"
        printf "${YELLOW}[!]${RESET} Are you sure 'open-vm-tools is installed ?\n"
        exit 1
    fi
        
    sleep 1
    printf "${GREEN}[+]${RESET} Adding 'vmware-user-suid-wrapper' to i3 config to enable copy/paste\n"
    
    if [ "$(ls $HOME/.config/i3/ | grep "config" | head -n 1 )" = "config" ]; then
        echo "exec vmware-user-suid-wrapper --no-startup-id" >> $HOME/.config/i3/config
    else
        printf "${RED}[-]${RESET} Cannot find i3 config, please check where your config file is placed and edit the script\n"
        exit 1
    fi
}

check_vmtools
exit 0
