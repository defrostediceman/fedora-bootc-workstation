FROM ghcr.io/defrostediceman/fedora-bootc-server

# ADD etc etc

# ADD usr usr

# Desktop Enrivonment
RUN dnf group install gnome-desktop base-graphical container-management core fonts hardware-support multimedia networkmanager-submodules printing workstation-product -y

# Required for Logically Bound images, see https://gitlab.com/fedora/bootc/examples/-/tree/main/logically-bound-images/usr/share/containers/systemd
# RUN ln -sr /etc/containers/systemd/*.container /usr/lib/bootc/bound-images.d/

RUN flatpak install flathub org.mozilla.firefox

# Set DE to start on boot
RUN systemctl set-default graphical.target 