# potential issues with 6.12 Kernel and COSMIC. Rawhide currently shipping with 6.13.0 as at Dec 24. 
FROM quay.io/fedora/fedora-bootc:40

COPY etc etc

RUN ln -sr /etc/containers/systemd/*.container /usr/lib/bootc/bound-images.d/ && \
    #mkdir -p /var/tmp && chmod -R 1777 /var/tmp && \
    #ln -sr /run /var/run/ && \
    mkdir -p /var/roothome /data /var/home /root/.cache/dconf 

# Add third party RPM repo & packages needed to use COPR from DNF5 
RUN dnf5 install -y \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
        dnf5-plugins \
        copr

#RUN dnf5 copr enable -y ryanabx/cosmic-epoch

RUN dnf5 -y install @gnome-desktop \
				@cosmic-desktop \
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
        bootupd \
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
        qemu-kvm \
        crun-vm \
        git \
        gh \
        neovim \
        vim-enhanced \
        tmux \
        bash-completion \
        buildah \
        flatpak \
        flatpak-builder \
        skopeo \
        toolbox \
				bootc \
        fedora-release-ostree-desktop \
        gnome-shell-extension-appindicator \
        gnome-shell-extension-dash-to-dock \
        gnome-tweaks \
        tuned-ppd \
        && dnf5 clean all

RUN systemctl set-default graphical.target && \
    systemctl enable --global gdm.service && \
    systemctl disable abrtd.service && \
    systemctl disable cosmic-greeter.service && \
    systemctl enable fstrim.timer && \ 
    systemctl enable cockpit.socket && \
    systemctl enable podman.socket && \
    systemctl enable podman-auto-update.timer && \
    systemctl enable fwupd.service && \
    systemctl disable auditd.service

RUN bootc container lint