#!/bin/bash
set -e

source settings
source include.sh

cancel_and_exit() {
  echo "Required cancel of release. Deleting the release" >&2
  delete_release
  exit 1
}

#
# Check we have something to upload
#
need_assets() {
  if [[ ! -d "$_OUTPUT" ]] ; then
    echo "ERROR: no work dir found"
    exit 1
  fi
}

#
# Create a release
#
create_release() {
  echo "Creating release $tag"
$ghr release \
    --tag "$tag" \
    --name "$release_name" \
    --description "automatic build" \
    --pre-release
}

#
# Upload the iso
#
upload_iso() {
need_assets

[[ ! -f ${_OUTPUT}/${_iso}.xz ]] && cancel_and_exit

echo "Uploading ${_iso}.xz..."
$ghr upload \
    --tag "$tag" \
    --name "${_iso}.xz" \
    --file "${_OUTPUT}/${_iso}.xz" || cancel_and_exit
echo "Uploading pkglist.x86_64.txt"
$ghr upload \
    --tag "$tag" \
    --name "pkglist.x86_64.txt" \
    --file "${_OUTPUT}/pkglist.x86_64.txt" || cancel_and_exit
}

#
# Make the release definitive
#
publish_release() {
echo "Publihing release $tag"
$ghr edit \
    --tag "$tag" \
    --name "GroovyArcade $tag" \
    --description "automatic build" || cancel_and_exit
}

#
# Remove a release
#
delete_release() {
echo "Deleting release $tag..."
$ghr delete \
    --tag "$tag"
}

_iso="groovyarcade-$(date +%Y.%m)-x86_64.iso"
tag=${GA_VERSION}

release_name="GroovyArcade $tag"
ghr=$([[ -f ~/go/bin/github-release ]] && echo "$HOME/go/bin/github-release" || echo "/usr/local/bin/github-release")

# Make sure all env vars exist
export GITHUB_TOKEN=${GITHUB_TOKEN:-$(cat ./GITHUB_TOKEN)}
[[ -z $GITHUB_USER ]] && (echo "GITHUB_USER is undefined, cancelling." ; exit 1 ;)
[[ -z $GITHUB_REPO ]] && (echo "GITHUB_REPO is undefined, cancelling." ; exit 1 ;)
# Allow a local build to release, the CI sets the GITHUB_TOKEN env var
if [[ -z $GITHUB_TOKEN ]] ; then
  echo "GITHUB_TOKEN is undefined, cancelling."
  exit 1
fi

# Parse command line
while getopts "cipd" option; do
  case "${option}" in
    c)
      create_release
      ;;
    i)
      upload_iso
      ;;
    p)
      publish_release
      ;;
    d)
      delete_release
      ;;
    *)
      echo "ERROR: options can be -c -i -p or -d only" >&2
      exit 1
      ;;
  esac
done
