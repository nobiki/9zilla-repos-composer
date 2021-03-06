#!/bin/bash

if [ ! -e /bootstrap.lock ]; then
  mv /git-daemon.conf.org /etc/supervisor/conf.d/git-daemon.conf
  /git-daemon.sh

  cp /usr/local/lib/satis/satis.json.org /repos/satis.json
  mkdir -p /repos/satis/
  chown 1000:1000 /repos/satis/

  touch /bootstrap.lock
fi

/usr/bin/supervisord -n
