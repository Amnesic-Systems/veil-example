#!/bin/sh

veil &
echo "[sh] Started veil."

ssh-keygen -A
echo "[sh] Configured SSH server."
exec /usr/sbin/sshd -D -e "$@"
