#!/bin/bash
set -x
INRELEASE="$RELEASE"
RELEASE=${RELEASE:-dev}
IMAGE_NAME="groovy-ux-os-${RELEASE}"

mkdir -p work/output work/fakeroot
chmod -R 777 work 2>/dev/null
echo "+++++++++++++++++++++++++++++"
echo "+++ Building docker image +++"
echo "+++++++++++++++++++++++++++++"
docker build -f Dockerfile -t "$IMAGE_NAME" . &&
echo "+++++++++++++++++++++++++++++"
echo "+++ Running container     +++"
echo "+++++++++++++++++++++++++++++"
#docker run --privileged --tty --name "$IMAGE_NAME" --rm -v "$(pwd)/work/output":/work/output -v "$(pwd)/work/fakeroot":/work/fakeroot "$IMAGE_NAME"
docker run --privileged --tty --name "$IMAGE_NAME" -e RELEASE="$INRELEASE" --rm -v "$(pwd)/work/output":/work/output "$IMAGE_NAME"
