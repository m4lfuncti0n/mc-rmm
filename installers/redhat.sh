UPDATE_URL="https://raw.githubusercontent.com/m4lfuncti0n/mc-rmm/master"
wget -q ${UPDATE_URL}/installers/common.sh -O /tmp/mc-rmm.common.sh
source /tmp/mc-rmm.common.sh && rm -f /tmp/mc-rmm.common.sh

function update_system_packages() {
    install_log "Updating sources"
    sudo yum update --skip-broken || install_error "Couldn't update packages"
}

function install_dependencies() {
    install_log "Installing required packages"
    sudo yum install screen rsync zip java jq || install_error "Couldn't install dependencies"
}

function enable_init() {
    install_log "Enabling automatic startup and shutdown"
    sudo chkconfig --add mc-rmm
}

install_mc-rmm
