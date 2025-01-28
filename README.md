# Fedora Bootc Workstation



## Todo list

- [ ] Gnome settings
  - [ ] dark mode
  - [ ] black wallpaper
  - [ ] minimize to tray
  - [ ] hide dock
  - [ ] reduce work spaces
- [ ] Remove applications
  - [ ] Firefox (flatpak & DNF)
  - [ ] Boxes
  - [ ] Contacts
  - [ ] Document scanner
  - [ ] Document viewer
  - [ ] Help
  - [ ] LibreOffice
  - [ ] Maps
  - [ ] Parental controls
  - [ ] Problem reporting
  - [ ] Remote view
  - [ ] Rhythmbox
  - [ ] Text editor
  - [ ] Videos
  - [ ] Virtual machine manager
  - [ ] Weather
- [ ] Install applications
  - [ ] VLC
  - [ ] Wireshark
  - [ ] LibreOffice
  - [ ] GIMP
  - [ ] Joplin
- [ ] COSMIC desktop
- [ ] GNOME extensions

## Building

```bash
sudo podman run \
    --rm  \
    -it \
    --privileged \
    --pull=newer \
    --net=host \
    --security-opt \
    label=type:unconfined_t \
    -v $(pwd)/output:/output \
    quay.io/centos-bootc/bootc-image-builder:latest \
    --type anaconda-iso \
    ghcr.io/defrostediceman/fedora-bootc-workstation
````