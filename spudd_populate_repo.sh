#!/usr/bin/env bash

#set -x

args=""

while getopts ":D" opt; do
  case $opt in
    D)
      echo "Deleting any locally removed files" >&2
      args="${args} --delete-removed"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

script_dir="$(dirname "$(readlink -f "$0")")"
local_repo=${script_dir}/local/arch

descend() {
  local current_dir=${1}
  for dir in $(ls -d */ 2>/dev/null); do
    cd ${current_dir}/${dir}
    tally
    descend ${PWD}
  done
  cd ${current_dir}
}

tally() {
  local db_name=qpi

  if [[ -n "$(echo $PWD | grep test)" ]]; then
    db_name="${db_name}-testing"
  fi

  for file in $(ls *.pkg.tar.xz 2>/dev/null); do
    echo "Adding $file to $dir DB"
    repo-add ${db_name}.db.tar.gz $file
  done
}

descend ${local_repo}

s3cmd sync -F ${args} ${local_repo} s3://spuddrepo/

exit 0
