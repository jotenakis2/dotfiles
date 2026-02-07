#!/usr/bin/env bash

# gestion passphrase ssh

export SSH_ASKPASS="/run/current-system/sw/bin/ksshaskpass"
sleep 5
ssh-add -l | grep -qi ed25519 || ssh-add ~/.ssh/id_ed25519 </dev/null
