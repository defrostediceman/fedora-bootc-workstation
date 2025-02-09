ARG PLATFORM=linux/arm64

FROM --platform=${PLATFORM} quay.io/fedora/fedora-bootc:41

COPY etc etc

RUN ln -sr /etc/containers/systemd/*.container /usr/lib/bootc/bound-images.d/ && \
    mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
    mkdir -p /data /var/home /root/.cache/dconf || true

# add third party RPM repo & packages needed to use COPR from DNF5 
RUN dnf5 install -y \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    dnf5 clean all && rm -rf /var/cache/libdnf5

RUN dnf5 install -y \
        @core \
        copr \
        dnf5-plugins \
        fwupd \
        cockpit \
        cockpit-networkmanager \
        cockpit-files \
        git \
        gh \
        vim-enhanced \
        bash-completion \
        tmux \
        tar && \
    dnf5 clean all && rm -rf /var/cache/libdnf5

#  Desktop support
RUN dnf5 install -y \
        @base-graphical \
        @multimedia \
        @fonts \
        @workstation-product \
        @hardware-support \
        @networkmanager-submodules \
        fedora-release-ostree-desktop \
        ptyxis \
        gnome-keyring \
        fprintd \
        fprintd-pam \
        tuned-ppd \
        xclip && \
    dnf5 clean all && rm -rf /var/cache/libdnf5

# Gnome desktop
RUN dnf5 install -y \
        @gnome-desktop \
        gdm \
        gnome-shell-extension-appindicator \
        gnome-shell-extension-dash-to-dock \
        gnome-tweaks && \
    dnf5 clean all && rm -rf /var/cache/libdnf5

# Cosmic desktop
RUN dnf5 copr enable -y ryanabx/cosmic-epoch && \
    dnf5 install -y cosmic-desktop && \
    dnf5 clean all && rm -rf /var/cache/libdnf5

# containerisation support
RUN dnf5 update -y && \
        dnf5 install -y \
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
RUN dnf5 install -y \
        @virtualization \
        cockpit-machines \
        crun-vm && \
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

RUN systemctl enable graphical.target && \
    systemctl set-default graphical.target && \
    systemctl enable fstrim.timer && \ 
    systemctl enable cockpit.socket && \
    systemctl enable podman.socket && \
    systemctl enable podman-auto-update.timer && \
    systemctl enable fwupd.service && \
    systemctl disable abrtd.service && \
    systemctl disable auditd.service

RUN ostree container commit && \
    bootc container lint