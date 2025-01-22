# Fedora Bootc Workstation

WIP

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