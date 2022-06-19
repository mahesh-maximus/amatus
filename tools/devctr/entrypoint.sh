#!/bin/sh

echo 11111

tmux

echo 22222

/sbin/tini "--"

exec "$@"
