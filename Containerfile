FROM ghcr.io/defrostediceman/fedora-bootc-server

# ADD etc etc

# ADD usr usr

# Desktop Enrivonment
RUN dnf group install -y gnome-desktop 

RUN dnf group install -y base-graphical 

RUN dnf group install -y container-management 

RUN dnf group install -y core

RUN dnf group install -y fonts

RUN dnf group install -y hardware-support

RUN dnf group install -y multimedia 

RUN dnf group install -y networkmanager-submodules 

RUN dnf group install -y workstation-product 

# Required for Logically Bound images, see https://gitlab.com/fedora/bootc/examples/-/tree/main/logically-bound-images/usr/share/containers/systemd
# RUN ln -sr /etc/containers/systemd/*.container /usr/lib/bootc/bound-images.d/

RUN flatpak install flathub org.mozilla.firefox

# Set DE to start on boot
RUN systemctl set-default graphical.target 