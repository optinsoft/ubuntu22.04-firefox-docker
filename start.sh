#!/bin/bash
set -e

if [ -n "$TZ" ] && [ -e "/usr/share/zoneinfo/$TZ" ]; then
    ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime
    echo "$TZ" > /etc/timezone
fi

mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

exec supervisord -c /etc/supervisor/conf.d/supervisord.conf
