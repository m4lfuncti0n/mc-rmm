mcrmm_dir="/opt/mc-rmm"
mcrmm_user="minecraft"
mcrmm_user_system=false
dl_dir="$(mktemp -d -t mc-rmm-XXX)"

# Outputs an mc-rmm INSTALL log line
function install_log() {
    echo -e "\n\033[1;32mmc-rmm INSTALL: $*\033[m"
}

# Outputs an mc-rmm INSTALL ERROR log line and exits with status code 1
function install_error() {
    echo -e "\n\033[1;37;41mmc-rmm INSTALL ERROR: $*\033[m"
    exit 1
}

### NOTE: all the below functions are overloadable for system-specific installs
### NOTE: some of the below functions MUST be overloaded due to system-specific installs

function config_installation() {
    install_log "Configure installation"
    echo -n "Install directory [${mcrmm_dir}]: "
    read input
    if [ ! -z "$input" ]; then
        mcrmm_dir="$input"
    fi

    echo -n "New server user to be created [${mcrmm_user}]: "
    read input
    if [ ! -z "$input" ]; then
        mcrmm_user="$input"
    fi

    echo -n "Add new user as system account? [y/N]: "
    read answer
    if [[ $answer != "y" ]]; then
        mcrmm_user_system=true
    fi

    echo -n "Complete installation with these values? [y/N]: "
    read answer
    if [[ $answer != "y"  && $answer != "Y"]]; then
        echo "Installation aborted."
        exit 0
    fi
}

# Runs a system software update to make sure we're using all fresh packages
function update_system_packages() {
    # OVERLOAD THIS
    install_error "No function definition for update_system_packages"
}

# Installs additional dependencies (screen, rsync, zip, wget) using system package manager
function install_dependencies() {
    # OVERLOAD THIS
    install_error "No function definition for install_dependencies"
}

# Verifies existence of or adds user for Minecraft server (default "minecraft")
function add_minecraft_user() {
    install_log "Creating default user '${mcrmm_user}'"
    if $mcrmm_user_system; then
        sudo useradd ${mcrmm_user} --home "$mcrmm_dir"
    else
        sudo useradd ${mcrmm_user} --system --home "$mcrmm_dir"
    fi
}

# Verifies existence and permissions of mc-rmm server directory (default /opt/mc-rmm)
function create_mcrmm_directories() {
    install_log "Creating mc-rmm directories"
    if [ ! -d "$mcrmm_dir" ]; then
        sudo mkdir -p "$mcrmm_dir" || install_error "Couldn't create directory '$mcrmm_dir'"
    fi
    sudo chown -R $mcrmm_user:$mcrmm_user "$mcrmm_dir" || install_error "Couldn't change file ownership for '$mcrmm_dir'"
}

# Fetches latest mc-rmm.conf, cron job, and init script
function download_latest_files() {
    if [ ! -d "$dl_dir" ]; then
        install_error "Temporary download directory was not created properly"
    fi

    install_log "Downloading latest mc-rmm configuration file"
    sudo wget ${UPDATE_URL}/mc-rmm.conf \
        -O "$dl_dir/mc-rmm.conf.orig" || install_error "Couldn't download configuration file"

    install_log "Downloading latest mc-rmm cron file"
    sudo wget ${UPDATE_URL}/cron/mc-rmm \
        -O "$dl_dir/mc-rmm.cron.orig" || install_error "Couldn't download cron file"

    install_log "Downloading latest mc-rmm version"
    sudo wget ${UPDATE_URL}/init/mc-rmm \
        -O "$dl_dir/mc-rmm.init.orig" || install_error "Couldn't download init file"
}

# Patches mc-rmm.conf and cron job to use specified username and directory
function patch_latest_files() {
    # patch config file
    install_log "Patching mc-rmm configuration file"
    sudo sed 's#USERNAME="minecraft"#USERNAME="'$mcrmm_user'"#g' "$dl_dir/mc-rmm.conf.orig" | \
        sed "s#/opt/mc-rmm#$mcrmm_dir#g" | \
        sed "s#UPDATE_URL=.*\$#UPDATE_URL=\"$UPDATE_URL\"#" >"$dl_dir/mc-rmm.conf"

    # patch cron file
    install_log "Patching mc-rmm cron file"
    sudo awk '{ if ($0 !~ /^#/) sub(/minecraft/, "'$mcrmm_user'"); print }' \
        "$dl_dir/mc-rmm.cron.orig" >"$dl_dir/mc-rmm.cron"

    # patch init file
    install_log "Patching mc-rmm init file"
    sudo cp "$dl_dir/mc-rmm.init.orig" "$dl_dir/mc-rmm.init"
}

# Installs mc-rmm.conf into /etc
function install_config() {
    install_log "Installing mc-rmm configuration file"
    sudo install -b -m0644 "$dl_dir/mc-rmm.conf" /etc/mc-rmm.conf
    if [ ! -e /etc/mc-rmm.conf ]; then
        install_error "Couldn't install configuration file"
    fi
}

# Installs mc-rmm.cron into /etc/cron.d
function install_cron() {
    install_log "Installing mc-rmm cron file"
    sudo install -m0644 "$dl_dir/mc-rmm.cron" /etc/cron.d/mc-rmm || install_error "Couldn't install cron file"
    sudo /etc/init.d/cron reload
}

# Installs init script into /etc/init.d
function install_init() {
    install_log "Installing mc-rmm init file"
    sudo install -b "$dl_dir/mc-rmm.init" /etc/init.d/mc-rmm || install_error "Couldn't install init file"

    install_log "Making mc-rmm accessible as the command 'mc-rmm'"
    sudo ln -s /etc/init.d/mc-rmm /usr/local/bin/mc-rmm
}

# Enables init script in default runlevels
function enable_init() {
    # OVERLOAD THIS
    install_error "No function defined for enable_init"
}

# Updates rest of mc-rmm using init script updater
function update_mc-rmm() {
    install_log "Asking mc-rmm to update itself"
    sudo /etc/init.d/mc-rmm update --noinput
}

# Updates rest of mc-rmm using init script updater
function setup_jargroup() {
    install_log "Setup default jar groups"
    sudo /etc/init.d/mc-rmm jargroup create minecraft minecraft
}

function install_complete() {
    install_log "Done. Type 'mc-rmm help' to get started. Have fun!"
}

function install_mc-rmm() {
    config_installation
    add_minecraft_user
    update_system_packages
    install_dependencies
    create_mcrmm_directories
    download_latest_files
    patch_latest_files
    install_config
    install_cron
    install_init
    enable_init
    update_mc-rmm
    setup_jargroup
    install_complete
}
