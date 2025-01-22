ARG PLATFORM=linux/arm64

FROM --platform=${PLATFORM} quay.io/fedora/fedora-bootc:rawhide

COPY etc etc

RUN ln -sr /etc/containers/systemd/*.container /usr/lib/bootc/bound-images.d/ && \
#    mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
    mkdir -p /data /var/home /root/.cache/dconf || true

# Add third party RPM repo & packages needed to use COPR from DNF5 
RUN dnf5 install -y \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
#        dnf5-plugins \
#        copr

#RUN dnf5 copr enable -y ryanabx/cosmic-epoch

RUN dnf5 -y install @gnome-desktop \
        @multimedia \
        @networkmanager-submodules \
        @base-graphical \
        @container-management \
        @core \
        @fonts \
        @guest-desktop-agents \
        @virtualization \
        @workstation-product \
        @hardware-support \
        fwupd \
        gnome-keyring \
	    gdm \
        ptyxis \
        cockpit \
        cockpit-podman \ 
        cockpit-storaged \
        cockpit-machines \
        cockpit-networkmanager \
        cockpit-files \
        strace \
        qemu-kvm \
        crun-vm \
        git \
        gh \
        neovim \
        vim-enhanced \
        tmux \
        bash-completion \
        flatpak \
        flatpak-builder \
        toolbox \
        fedora-release-ostree-desktop \
        gnome-shell-extension-appindicator \
        gnome-shell-extension-dash-to-dock \
        gnome-tweaks \
        tuned-ppd \
        python3.11 \
        osbuild-selinux \
        xclip \
        && dnf5 clean all

# Flatpak install
COPY flatpak.toml .

RUN if [ "$PLATFORM" = "linux/amd64" ]; then \
        mkdir -p /var/roothome && \
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && \
        wget https://codeberg.org/HeliumOS/flatpak-readonlyroot/raw/branch/master/flatpak-readonlyroot.py && \
        chmod +x flatpak-readonlyroot.py && \
        python3.11 flatpak-readonlyroot.py flatpak.toml && \
        dnf remove -y python3.11 && \
        rm -rdf flatpak-readonlyroot.py flatpak.toml /var/roothome ; \
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

RUN bootc container lint