UPDATE_URL="https://raw.githubusercontent.com/m4lfuncti0n/mc-rmm/master"
curl -L "${UPDATE_URL}/installers/common.sh" -o /tmp/mc-rmm.common.sh  #wget isn't installed on Arch by default
source /tmp/mc-rmm.common.sh && rm -f /tmp/mc-rmm.common.sh

function update_system_packages() {
    install_log "Updating sources"
    sudo pacman -Syy || install_error "Couldn't update packages"
}

function install_dependencies() {
    install_log "Installing required packages"
    sudo pacman --noconfirm -S screen rsync zip wget jq || install_error "Couldn't install dependencies"
}

function enable_init() {
    install_log "Installing systemd service unit"
    sudo wget ${UPDATE_URL}/init/mc-rmm.service \
        -O /etc/systemd/system/mc-rmm.service
    
    install_log "Enabling automatic startup and shutdown"
    sudo systemctl enable mc-rmm.service
}

# Verifies existence and permissions of mc-rmm server directory (default /opt/mc-rmm)
function create_mc-rmm_directories() {
    install_log "Creating mc-rmm directories"
    if [ ! -d "$mc-rmm_dir" ]; then
        sudo mkdir -p "$mc-rmm_dir" || install_error "Couldn't create directory '$mc-rmm_dir'"
    fi
    sudo chown -R $mc-rmm_user:$mc-rmm_user "$mc-rmm_dir" || install_error "Couldn't change file ownership for '$mc-rmm_dir'"
    
    if [ ! -d "/etc/init.d" ]; then
        sudo mkdir -p "/etc/init.d/" || install_error "Couldn't create directory '/etc/init.d'"
    fi
}

install_mc-rmm
