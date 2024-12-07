FROM ghcr.io/defrostediceman/fedora-bootc-server

# ADD etc etc

# ADD usr usr

# Third party repo
RUN dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Trying each package from Core group
RUN dnf install -y audit basesystem bash coreutils curl dhcp-client dnf5 e2fsprogs filesystem glibc hostname iproute iputils kbd less man-db ncurses openssh-clients openssh-server parted policycoreutils procps-ng rpm selinux-policy-targeted setup shadow-utils sssd-common sssd-kcm sudo systemd util-linux vim-minimal NetworkManager dnf5-plugins dracut-config-rescue firewalld fwupd plymouth systemd-resolved zram-generator-defaults dracut-config-generic initial-setup initscripts

# Desktop Enrivonment
RUN dnf group install -y gnome-desktop 

RUN dnf group install -y base-graphical 

RUN dnf group install -y container-management 

# GitHub Actions failing to build when core is installing.
# RUN dnf group install -y core

RUN dnf group install -y fonts

RUN dnf group install -y hardware-support

RUN dnf group install -y multimedia 

RUN dnf group install -y networkmanager-submodules 

RUN dnf group install -y workstation-product 

RUN dnf group install -y container-management

# Required for Logically Bound images, see https://gitlab.com/fedora/bootc/examples/-/tree/main/logically-bound-images/usr/share/containers/systemd
# RUN ln -sr /etc/containers/systemd/*.container /usr/lib/bootc/bound-images.d/

# Flatpaks not successful during GHA build. Need a spike on this.
# RUN flatpak install flathub org.mozilla.firefox

# Set DE to start on boot
RUN systemctl set-default graphical.target 