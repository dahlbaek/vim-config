#!/bin/sh

if [ "$1" = --pull ] ; then
  shift
  sbt pullRemoteCache
fi

exec /usr/bin/nvim "$@"

