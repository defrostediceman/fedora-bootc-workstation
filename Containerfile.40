ARG PLATFORM=linux/arm64
FROM --platform=${PLATFORM} quay.io/fedora/fedora-bootc:40
COPY etc etc
RUN ln -sr /etc/containers/systemd/*.container /usr/lib/bootc/bound-images.d/ && \
    mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
    mkdir -p /data /var/home /root/.cache/dconf || true

# add third party RPM repo & packages
RUN dnf install -y \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    dnf clean all && rm -rf /var/cache/dnf

RUN dnf install -y \
        @core \
        dnf-plugins-core \
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
    dnf clean all && rm -rf /var/cache/dnf

#  Desktop support
RUN dnf install -y \
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
    dnf clean all && rm -rf /var/cache/dnf

# Gnome desktop
RUN dnf install -y \
        @gnome-desktop \
        gdm \
        gnome-shell-extension-appindicator \
        gnome-shell-extension-dash-to-dock \
        gnome-tweaks && \
    dnf clean all && rm -rf /var/cache/dnf

# Cosmic desktop
RUN dnf copr enable -y ryanabx/cosmic-epoch && \
    dnf install -y cosmic-desktop && \
    dnf clean all && rm -rf /var/cache/dnf

# containerisation support
RUN dnf update -y && \
        dnf install -y \
        @container-management \
        podman \
        buildah \
        toolbox \
        cockpit-podman \
        flatpak \
        flatpak-builder \
        osbuild-selinux \
        skopeo && \
    dnf clean all && rm -rf /var/cache/dnf

# virtualisation support
RUN dnf install -y \
        @virtualization \
        cockpit-machines \
        crun-vm && \
    dnf clean all && rm -rf /var/cache/dnf

# flatpak config copy
COPY flatpak.toml .

# flatpak install (amd64 only)
RUN if [ "$PLATFORM" = "linux/amd64" ]; then \
        dnf install -y python3.11 wget && \
        mkdir -p /var/roothome && \
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && \
        wget https://codeberg.org/HeliumOS/flatpak-readonlyroot/raw/branch/master/flatpak-readonlyroot.py && \
        chmod +x flatpak-readonlyroot.py && \
        python3.11 flatpak-readonlyroot.py flatpak.toml && \
        dnf remove -y python3.11 && \
        dnf clean all && rm -rf /var/cache/dnf && \
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