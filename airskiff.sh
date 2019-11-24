#!/bin/bash
set -xe

: "${INSTALL_PATH:="$(pwd)/../"}"
: "${PEGLEG:="./tools/airship pegleg"}"
: "${PL_SITE:="airskiff"}"
: "${TARGET_MANIFEST:="cluster-bootstrap"}"

# Render documents
${PEGLEG} site -r . render "${PL_SITE}" -o airskiff.yaml

# Set permissions o+r, beacause these files need to be readable
# for Armada in the container
AIRSKIFF_PERMISSIONS=$(stat --format '%a' airskiff.yaml)
KUBE_CONFIG_PERMISSIONS=$(stat --format '%a' ~/.kube/config)

sudo chmod 0644 airskiff.yaml
sudo chmod 0644 ~/.kube/config

# In the event that this docker command fails, we want to continue the script
# and reset the file permissions.
set +e

# Download latest Armada image and deploy Airship components
docker run --rm --net host -p 8000:8000 --name armada \
    -v ~/.kube/config:/armada/.kube/config \
    -v "$(pwd)"/airskiff.yaml:/airskiff.yaml \
    -v "${INSTALL_PATH}":/airship-components \
    quay.io/airshipit/armada:latest-ubuntu_bionic \
    apply /airskiff.yaml --target-manifest $TARGET_MANIFEST

# Set back permissions of the files
sudo chmod "${AIRSKIFF_PERMISSIONS}" airskiff.yaml
sudo chmod "${KUBE_CONFIG_PERMISSIONS}" ~/.kube/config
