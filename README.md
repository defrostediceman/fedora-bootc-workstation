# Fedora Bootc Workstation

WIP

## BIB

sudo podman run  --platform linux/amd64 \
    --rm  \
    -it \
    --privileged \
    --pull=newer \
    --net=host \
    --security-opt \
    label=type:unconfined_t \
    -v $(pwd)/config.example.toml:/config.toml:ro \
    -v $(pwd)/output:/output \
    quay.io/centos-bootc/bootc-image-builder:latest \
    --type anaconda-iso \
    --target-arch x86_64 \
    ghcr.io/defrostediceman/fedora-bootc-workstation