#!/bin/bash

if [ ! -e /bootstrap.lock ]; then

  touch /bootstrap.lock
fi

/git-daemon.sh
