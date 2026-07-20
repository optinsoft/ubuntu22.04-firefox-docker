#!/bin/bash
set -e

mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

exec supervisord -c /etc/supervisor/conf.d/supervisord.conf
