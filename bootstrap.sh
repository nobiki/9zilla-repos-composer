#!/bin/bash

if [ ! -e /bootstrap.lock ]; then
  mv /git-daemon.conf.org /etc/supervisor/conf.d/git-daemon.conf
  /git-daemon.sh

  touch /bootstrap.lock
fi

/usr/bin/supervisord -n
