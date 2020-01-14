BASE_URL="https://raw.githubusercontent.com/m4lfuncti0n/mc-rmm/master/installers/"

function check_os() {
    if [[ -f /etc/debian_version ]]; then
        INSTALL_SCRIPT="debian.sh"
    elif [[ -f /etc/redhat-release ]]; then
        INSTALL_SCRIPT="redhat.sh"
    elif [[ -f /etc/arch-release ]]; then
        INSTALL_SCRIPT="arch.sh"
    else
        echo "Error, unsupported distribution. Please install manually."
        exit 1
    fi
}

function get_installer() {
    type curl 1>/dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        curl -L "${BASE_URL}/${INSTALL_SCRIPT}" -o /tmp/mc-rmm.inst.sh
    else
        wget -q "${BASE_URL}/${INSTALL_SCRIPT}" -O /tmp/mc-rmm.inst.sh
    fi
    chmod u+x /tmp/mc-rmm.inst.sh
}

function do_install() {
    if [[ -f /tmp/mc-rmm.inst.sh ]]; then
        /tmp/mc-rmm.inst.sh && rm -f /tmp/mc-rmm.inst.sh
    else
        echo "Error, failed to download install script."
        exit 1
    fi
}

check_os
get_installer
do_install
