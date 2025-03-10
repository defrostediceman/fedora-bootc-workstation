ARG PLATFORM=linux/arm64

FROM --platform=${PLATFORM} quay.io/fedora/fedora-bootc:42

COPY etc etc

RUN mkdir -p /data /var/home /root/.cache/dconf /root/.gnupg|| true && \
    #ln -sr /etc/containers/systemd/*.container /usr/lib/bootc/bound-images.d/ && \
    #ln -sr /etc/containers/systemd/*.image /usr/lib/bootc/bound-images.d/ && \
    mkdir -p /var/tmp && chmod -R 1777 /var/tmp


# add third party RPM repo & packages needed to use COPR from DNF5 
RUN dnf5 remove --assumeyes \
        subscription-manager \
        abrt* \
        setroubleshoot \
        nano && \
    dnf5 install --assumeyes --nogpgcheck \
        #https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    dnf5 clean all && rm -rf /var/cache/libdnf5

RUN dnf5 install --assumeyes --exclude=rootfiles --skip-broken \
        @core \
        copr \
        dnf5-plugins \
        fwupd \
        git \
        gh \
        vim-enhanced \
        bash-completion \
        tmux && \
    dnf5 clean all && rm -rf /var/cache/libdnf5

#  Desktop support
RUN dnf5 install --assumeyes --skip-broken \
        @base-graphical \
        @multimedia \
        @fonts \
        @workstation-product \
        @hardware-support \
        @networkmanager-submodules \
        fedora-release-ostree-desktop \
        flatpak \
        ptyxis \
        gnome-keyring \
        fprintd \
        fprintd-pam \
        tuned-ppd \
        xclip && \
    dnf5 clean all && rm -rf /var/cache/libdnf5

# Gnome desktop
RUN dnf5 install --assumeyes --skip-broken \
        @gnome-desktop \
        gdm \
        gnome-shell \
        gnome-shell-extension-common \
        gsettings-desktop-schemas \
        gnome-settings-daemon \
        gnome-shell-extension-appindicator \
        gnome-shell-extension-dash-to-dock \
        gnome-shell-extension-blur-my-shell \
        gnome-shell-extension-gsconnect \
        gnome-shell-extension-caffeine \
        #gnome-shell-extension-fullscreen-to-empty-workspace \
        gnome-shell-extension-workspace-indicator \
        #gnome-shell-extension-app-indicator \
        gnome-shell-extension-background-logo \
        gnome-tweaks && \
    dnf5 clean all && rm -rf /var/cache/libdnf5

# Cosmic desktop
RUN dnf5 copr enable -y ryanabx/cosmic-epoch && \
    dnf5 install --assumeyes --skip-broken cosmic-desktop && \
    dnf5 clean all && rm -rf /var/cache/libdnf5

# containerisation support
RUN dnf5 install --assumeyes --skip-broken \
        @container-management \
        podman \
        buildah \
        toolbox \
        cockpit-podman \
        flatpak \
        flatpak-builder \
        osbuild-selinux \
        skopeo && \
    dnf5 clean all && rm -rf /var/cache/libdnf5

# virtualisation support
RUN dnf5 install --assumeyes --skip-broken \
        @virtualization \
        cockpit-machines \
        crun-vm && \
    dnf5 clean all && rm -rf /var/cache/libdnf5

# Nvidia driver
RUN dnf5 install --assumeyes --skip-broken \
        nvidia-driver \
        nvidia-container-toolkit && \
    rm /var/log/*.log /var/lib/dnf5 -rf && \
    dnf5 clean all

# cockpit install
COPY tmp/cockpit.desktop /usr/share/applications/cockpit.desktop

RUN dnf5 install --assumeyes --skip-broken \
        cockpit \
        cockpit-networkmanager \
        cockpit-files \
        cockpit-selinux \
        cockpit-ostree && \
    dnf5 clean all && rm -rf /var/cache/libdnf5 && \
    chmod +x /usr/share/applications/cockpit.desktop

# podman-bootc install
RUN dnf5 copr enable -y gmaglione/podman-bootc && \
    dnf5 install --assumeyes --skip-broken podman-bootc && \
    dnf5 clean all && rm -rf /var/cache/libdnf5

# Cursor.ai appimage
COPY tmp/cursor.desktop /usr/share/applications/cursor.desktop

RUN curl -Lo /usr/local/bin/cursor https://downloader.cursor.sh/linux/appImage/x64 && \
    chmod +x /usr/local/bin/cursor /usr/share/applications/cursor.desktop && \
    curl -Lo /usr/local/bin/cursor.png https://custom.typingmind.com/assets/models/cursor.png || { echo "Failed to download cursor.png"; exit 1; }

# gnome unwanted removal
RUN dnf5 remove --assumeyes --exclude="gnome-shell" --exclude="gnome-desktop*" --exclude="gdm" --noautoremove \
        gnome-text-editor \
        gnome-maps \
        gnome-weather \
        gnome-calendar \
        gnome-clocks \
        gnome-characters \
        gnome-calculator \
        gnome-tour \
        gnome-font-viewer \
        gnome-system-monitor \
        gnome-remote-desktop \
        gnome-user-docs \
        papers \
        snapshot \
        baobab \
        virt-manager \
        gnome-color-manager \
        gnome-boxes \
        firefox && \
    dnf5 autoremove --assumeyes && \
    dnf5 clean all && rm -rf /var/cache/libdnf5

# flatpak config copy
COPY flatpak.toml .

# flatpak install (amd64 only)
RUN if [ "$PLATFORM" = "linux/amd64" ]; then \
        dnf5 install -y python3.11 wget && \
        mkdir -p /var/roothome && \
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && \
        wget https://codeberg.org/HeliumOS/flatpak-readonlyroot/raw/branch/master/flatpak-readonlyroot.py && \
        chmod +x flatpak-readonlyroot.py && \
        python3.11 flatpak-readonlyroot.py flatpak.toml && \
        dnf5 remove -y python3.11 && \
        dnf5 clean all && rm -rf /var/cache/libdnf5 && \
        rm -rdf flatpak-readonlyroot.py flatpak.toml /var/roothome ; \
    fi

# homebrew install
RUN if [ "$PLATFORM" = "linux/amd64" ]; then \
        mkdir -p /var/roothome && \
        curl --retry 3 -Lo /tmp/brew-install/install.sh https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh && \
        chmod +x /tmp/brew-install/install.sh && \
        /tmp/brew-install/install.sh && \
        tar --zstd -cvf /usr/share/homebrew.tar.zst /home/linuxbrew && \
        rm -rf /.dockerenv /home/linuxbrew /root/.cache /var/home ; \
    fi

RUN systemctl set-default graphical.target && \
    systemctl enable \
        fstrim.timer \
        cockpit.socket \
        podman.socket \
        podman-auto-update.timer \
        fwupd.service && \
    systemctl disable \
        abrtd.service \
        auditd.service && \
    systemctl mask \
        abrtd.service \
        auditd.service

RUN ostree container commit && \
    bootc container lint