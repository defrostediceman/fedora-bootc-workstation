FROM quay.io/fedora/fedora-bootc:41

RUN ln -sf /run /var/run && \
    mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
    mkdir -p /var/roothome /data /var/home /root/.cache/dconf 

# Add third party repo & needed to use COPR from DNF5 
RUN dnf5 install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
        dnf5-plugins \
        copr

# Add Cosmic COPR. Note: this is included in 41 but the COPR ships quicker updates so very Alpha.
RUN dnf5 copr enable -y ryanabx/cosmic-epoch

# Install groups & packages
RUN dnf5 -y install @cosmic-desktop \
        @cosmic-desktop-apps \
        @multimedia \
        @networkmanager-submodules \
        @base-graphical \
        @container-management \
        @core \
        @fonts \
        @virtualization \
        @workstation-product \
        @hardware-support \
        gstreamer1-plugins-{bad-free,bad-free-libs,good,base} \
        lame{,-libs} \
        libjxl \
        plymouth \
        plymouth-system-theme \
        fwupd \
        gnome-keyring \
        ptyxis \
        cockpit \
        cockpit-podman \ 
        cockpit-storaged \
        cockpit-machines \
        cockpit-networkmanager \
        cockpit-files \
        qemu \
        crun-vm \
        git \
        neovim \
        tmux \
        bash-completion \
        buildah \
        flatpak \
        flatpak-builder \
        skopeo \
        toolbox \
        && dnf5 clean all

RUN dnf5 -y remove console-login-helper-messages

RUN systemctl disable gdm.service && \
    systemctl enable fstrim.timer && \ 
    systemctl enable cockpit.socket && \
    systemctl enable podman.socket && \
    systemctl enable podman-auto-update.timer && \
    systemctl enable cosmic-greeter.service && \
    systemctl enable fwupd.service && \
    systemctl set-default graphical.target

RUN ostree container commit

RUN bootc container lint