#!/bin/bash

UPDATE_URL="https://raw.githubusercontent.com/m4lfuncti0n/mc-rmm/master"
wget -q ${UPDATE_URL}/installers/common.sh -O /tmp/mc-rmm.common.sh
source /tmp/mc-rmm.common.sh && rm -f /tmp/mc-rmm.common.sh

function update_system_packages() {
    install_log "Updating sources"
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ $NAME == 'Ubuntu' ]; then
            sudo add-apt-repository universe || install_error "Couldn't enable universe repository"
        fi
    fi
    sudo apt-get update || install_error "Couldn't update package list"
    sudo apt-get upgrade || install_error "Couldn't upgrade packages"
}

function install_dependencies() {
    install_log "Installing required packages"
    sudo apt-get install screen rsync zip jq || install_error "Couldn't install dependencies"
}

function enable_init() {
    install_log "Enabling automatic startup and shutdown"
    hash insserv 2>/dev/null
    if [[ $? == 0 ]]; then
        sudo insserv mc-rmm
    else
        sudo update-rc.d mc-rmm defaults 99 10
    fi
}

install_mc-rmm
