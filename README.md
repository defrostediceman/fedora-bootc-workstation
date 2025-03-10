# Fedora Bootc Workstation

Still is very much in active development. Expect changes, expect bugs and expect it to break. 

## Generating ISO

To do this we use `bootc-image-builder` from `quay.io/centos-bootc/bootc-image-builder:latest` aka `BiB`. `BiB` is a tool that builds bootable ISOs. In the latest release, it requires the image to be stored locally prior to building the ISO. therefore please either pull or build the image and store it locally prior to attempting to build the ISO.

```bash
podman pull ghcr.io/defrostediceman/fedora-bootc-workstation:latest
```
or build it yourself

```bash
git clone https://github.com/defrostediceman/fedora-bootc-workstation.git
cd fedora-bootc-workstation
podman build -t ghcr.io/defrostediceman/fedora-bootc-workstation:latest .
```

Now thats done, we can (attempt to) build the ISO :eyes:

```bash
sudo podman run     --rm \
    -it \
    --privileged \
    --pull=newer \
    --net=host \
    --security-opt \
    label=type:unconfined_t \
    -v $(pwd)/config.toml:/config.toml \
    -v $(pwd)/output:/output \
    -v /var/lib/containers/storage:/var/lib/containers/storage \
    quay.io/centos-bootc/bootc-image-builder:latest \
    --type anaconda-iso \
    ghcr.io/defrostediceman/fedora-bootc-workstation:latest

```

## Roadmap

## Todo list

- [ ] Gnome settings
  - [ ] dark mode
  - [ ] black wallpaper
  - [ ] minimize to tray
  - [ ] hide dock
  - [ ] reduce work spaces
- [ ] Remove applications
  - [x] Firefox (flatpak & DNF)
  - [x] Boxes
  - [x] Contacts
  - [x] Document scanner
  - [x] Document viewer
  - [x] Help
  - [ ] LibreOffice
  - [x] Maps
  - [ ] Parental controls
  - [ ] Problem reporting
  - [ ] Remote view
  - [ ] Rhythmbox
  - [x] Text editor
  - [ ] Videos
  - [x] Virtual machine manager
  - [x] Weather
- [ ] Install applications as Flatpak
  - [x] VLC
  - [x] Wireshark
  - [ ] LibreOffice
  - [ ] GIMP
  - [x] Joplin
- [x] COSMIC desktop
- [x] GNOME extensions