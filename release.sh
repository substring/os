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
$ghr release create "$tag" \
    -R "$GITHUB_USER"/"$GITHUB_REPO" \
    --title "$release_name" \
    --notes "$(prepare_description)" \
    --prerelease
}

#
# Upload the iso
#
upload_iso() {
need_assets

[[ ! -f ${_OUTPUT}/${_iso}.xz ]] && cancel_and_exit

echo "Uploading ${_iso}.xz..."
$ghr release upload "$tag" \
    "${_OUTPUT}/${_iso}.xz" \
    -R "$GITHUB_USER"/"$GITHUB_REPO" \
    --clobber || cancel_and_exit
echo "Uploading pkglist.x86_64.txt"
$ghr release upload "$tag" "${_OUTPUT}/pkglist.x86_64.txt" \
    -R "$GITHUB_USER"/"$GITHUB_REPO" \
    --clobber || cancel_and_exit
}

#
# Prepare a description
#

prepare_description() {
  last_tag=$(git describe --tags --abbrev=0 @^)
  last_tag_date=$(git log -1 --format=%ai "$last_tag")
  os_commits_since_last_tag=$(git log --pretty=format:%s "$last_tag"..@ | sed "s/^/- /")

  [[ -d packages ]] && rm -rf packages
  git clone --single-branch https://gitlab.com/groovyarcade/packages.git
  cd packages
  packages_commits_since_last_tag=$(git log --pretty=format:%s --since="$last_tag_date" | sed "s/^/- /")
  cd ..

  [[ -d gatools ]] && rm -rf gatools
  git clone --single-branch https://gitlab.com/groovyarcade/tools/gatools.git
  cd gatools
  gatools_commits_since_last_tag=$(git log --pretty=format:%s --since="$last_tag_date" | sed "s/^/- /")
  cd ..

  [[ -d gasetup ]] && rm -rf gasetup
  git clone --single-branch https://gitlab.com/groovyarcade/gasetup.git
  cd gasetup
  gasetup_commits_since_last_tag=$(git log --pretty=format:%s --since="$last_tag_date" | sed "s/^/- /")
  cd ..

  pkg_version=$(</work/output/pkglist.x86_64.txt)
  final_desc=$(echo -e "**OS changes:** \n
$os_commits_since_last_tag\n
**Packages changes:**\n
$packages_commits_since_last_tag\n
**gasetup changes:**\n
$gasetup_commits_since_last_tag\n
**gatools changes:**\n
$gatools_commits_since_last_tag\n
<details>
  <summary><b>Packages included:</b></summary>\n\n
$pkg_version
</details>
")
  echo "$final_desc"
}

#
# Make the release definitive
#
publish_release() {
echo "Publihing release $tag"
$ghr release edit "$tag" \
    -R "$GITHUB_USER"/"$GITHUB_REPO" \
    --title "GroovyArcade $tag" \
    --notes "$(prepare_description)" || cancel_and_exit
}

#
# Remove a release
#
delete_release() {
echo "Deleting release $tag..."
$ghr release delete "$tag" \
    -R "$GITHUB_USER"/"$GITHUB_REPO" \
    --yes || return 0
}

_iso="groovyarcade-$(date +%Y.%m)-x86_64.iso"
tag=${GA_VERSION}

release_name="GroovyArcade $tag"
ghr=gh

# Make sure all env vars exist
export GITHUB_TOKEN=${GITHUB_TOKEN:-$(<./GITHUB_TOKEN)}
[[ -z $GITHUB_USER ]] && (echo "GITHUB_USER is undefined, cancelling." ; exit 1 ;)
[[ -z $GITHUB_REPO ]] && (echo "GITHUB_REPO is undefined, cancelling." ; exit 1 ;)
# Allow a local build to release, the CI sets the GITHUB_TOKEN env var
if [[ -z $GITHUB_TOKEN ]] ; then
  echo "GITHUB_TOKEN is undefined, cancelling."
  exit 1
fi

# Parse command line
while getopts "cipdo" option; do
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
    o)
      prepare_description
      ;;
    *)
      echo "ERROR: options can be -c -i -p or -d only" >&2
      exit 1
      ;;
  esac
done
