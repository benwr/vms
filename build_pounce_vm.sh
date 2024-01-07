#!/bin/sh
# This script generates a new pounce vm and runs it.
# If you haven't already set them up in the mounted dirs, you'll need to:
# 1. set up ssh host using `ssh-keygen -A`
# 2. set up tailscale using `tailscale up --ssh`
# 3. set up pounce config, using e.g. pounce -g
SCRIPT_NAME=$(guix system vm pounce.scm --no-substitutes --no-graphic --share=/tank/ben/pounce/log=/var/log --share=/tank/ben/pounce/ssh=/etc/ssh --share=/tank/ben/pounce/tailscale=/var/lib/tailscale --share=/tank/ben/pounce/etc=/etc/pounce --share=/tank/ben/pounce/var=/var/pounce)
$SCRIPT_NAME -nic user,model=virtio-net-pci
GCROOT=/var/guix/gcroots/pouncevm
sudo rm "$GCROOT"
echo "$SCRIPT_NAME"
sudo ln -s "$SCRIPT_NAME" "$GCROOT"
echo "VM script now symlinked to /var/guix/gcroots/pouncevm."
echo "Run it as a non-root user, with '-nic user,model=virtio-net-pci'"
