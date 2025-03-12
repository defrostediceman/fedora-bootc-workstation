#!/bin/bash

# Make sure we have the proper environment for gsettings, currently profile.d is doing this for us though.
# export XDG_DATA_DIRS="${XDG_DATA_DIRS}:/usr/local/share:/usr/share:/usr/share/gnome"

# Log file for debugging
LOG_FILE="/var/log/gnome-settings.log"
echo "GNOME settings script started at $(date) for user $USER" >> "$LOG_FILE"


# Function to run a command and log the result
run_cmd() {
  echo "Running: $*" >> "$LOG_FILE"
  "$@" || echo "Failed: $*" >> "$LOG_FILE"
}

# Enable extensions if gnome-extensions command is available
if command -v gnome-extensions >/dev/null 2>&1; then
    run_cmd gnome-extensions enable dash-to-dock@micxgx.gmail.com
    run_cmd gnome-extensions enable caffeine@patapon.info
    run_cmd gnome-extensions enable blur-my-shell@aunetx
fi

# Background and appearance
run_cmd gsettings set org.gnome.desktop.background picture-uri ""
run_cmd gsettings set org.gnome.desktop.background picture-uri-dark ""
run_cmd gsettings set org.gnome.desktop.background primary-color "#000000"
run_cmd gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
run_cmd gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
run_cmd gsettings set org.gnome.desktop.interface icon-theme "Adwaita"

# Window management
run_cmd gsettings set org.gnome.desktop.wm.preferences button-layout "close,minimize,maximize:"
run_cmd gsettings set org.gnome.desktop.wm.preferences num-workspaces 1
run_cmd gsettings set org.gnome.desktop.wm.preferences mouse-button-modifier "<Alt>"
run_cmd gsettings set org.gnome.mutter center-new-windows true
run_cmd gsettings set org.gnome.desktop.interface enable-animations false

# Nautilus (File manager) settings
run_cmd gsettings set org.gnome.nautilus.preferences show-hidden-files true
run_cmd gsettings set org.gnome.nautilus.preferences default-folder-viewer "list-view"
run_cmd gsettings set org.gnome.nautilus.list-view default-zoom-level "standard"
run_cmd gsettings set org.gnome.nautilus.preferences always-use-location-entry true

# Night light settings
run_cmd gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
run_cmd gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 4000
run_cmd gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true

# Dash to dock settings
run_cmd gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
run_cmd gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
run_cmd gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
run_cmd gsettings set org.gnome.shell.extensions.dash-to-dock apply-custom-theme true
run_cmd gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true
run_cmd gsettings set org.gnome.shell.extensions.dash-to-dock show-trash true
run_cmd gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts-only-mounted true

# Power settings
run_cmd gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 1800
run_cmd gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 900
run_cmd gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'suspend'
# run_cmd gsettings set org.gnome.settings-daemon.plugins.power power-mode 'performance'

# Session idle settings
run_cmd gsettings set org.gnome.desktop.session idle-delay 300

# Touchpad settings
run_cmd gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
run_cmd gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false
run_cmd gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing true

# Workspace settings
run_cmd gsettings set org.gnome.mutter workspaces-only-on-primary false

# Set favorite applications
run_cmd gsettings set org.gnome.shell favorite-apps \
    "['org.gnome.Nautilus.desktop', \
    'org.gnome.Settings.desktop', \
    'org.signal.Signal.desktop', \
    'org.gnome.Ptyxis.desktop', \
    'cursor.desktop', \
    'org.mozilla.firefox.desktop']"

echo "GNOME settings script completed at $(date)" >> "$LOG_FILE"