#!/usr/bin/env bash

script_dir="$(dirname "$(readlink -f "$0")")"
local_repo=${script_dir}/local

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

s3cmd sync -F --delete-removed ~/repo/local/* s3://spuddrepo/arch

#echo "Refreshed DBs; do you want to deploy to s3?"
#read i
#
#if [[ "$i" = "yes" ]]; then
#  deploy_dir="${script_dir}/s3/arch"
#  rm -Rf ${deploy_dir}
#  mkdir -p ${deploy_dir}
#  cp -rL ${local_repo}/* ${deploy_dir}
#fi
