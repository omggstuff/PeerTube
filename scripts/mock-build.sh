#!/bin/bash

set -eu

shutdown() {
  # Get our process group id
  # shellcheck disable=SC2009
  PGID=$(ps -o pgid= $$ | grep -o "[0-9]*")

  # Kill it in a new new process group
  setsid kill -- -"$PGID"
  exit 0
}

trap "shutdown" SIGINT SIGTERM

today=$(date '+%F')
directory_name="peertube-nightly-$today"
tar_name="peertube-nightly-$today.tar.xz"

testfile=testfile.txt
touch $testfile

(
  # temporary setup
  cd ..
  ln -s "PeerTube" "$directory_name"

  XZ_OPT=-e9 tar cfJ "PeerTube/$tar_name" "$directory_name/$testfile"

  # temporary setup destruction
  rm "$directory_name"
)

echo "Running `ls .`"
ls .

echo "Running `ls PeerTube`"
ls PeerTube
