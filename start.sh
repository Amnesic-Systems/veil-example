#!/bin/sh

veil -fqdn example.com -wait-for-app &
echo "[sh] Started veil."

sleep 1

enclave-app.py
echo "[sh] Ran Python script."
