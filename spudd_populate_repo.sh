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

cd ${local_repo}
for dir in $(ls -d */); do
  echo "Operating on $dir"
  cd ${local_repo}/${dir}
  for file in $(ls *.pkg.tar.xz); do
    echo "Adding $file to $dir DB"
    repo-add qpi.db.tar.gz $file 
  done
  cd ..
done

s3cmd sync -F ${args} ${local_repo} s3://spuddrepo/

exit 0
