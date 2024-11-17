# veil examples

This repository contains example enclave applications that build on top of
[veil](https://github.com/Amnesic-Systems/veil).

## ssh-server

This example runs an OpenSSH server inside an enclave.
First, build and start the OpenSSH server by running:

```
make run app=ssh-server
```

Next, you can connect to it by running the following command.
The password is `root`.
```
ssh root@10.0.0.2
```

## python-fetcher

This example runs a Python script that fetches a page over the Internet.
Build and start the script by running:

```
make run app=python-fetcher
```