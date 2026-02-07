#!/usr/bin/env bash
echo ""
echo "---------------------- RPM ---------------------------"
sudo dnf update --refresh
echo "---------------------- /RPM --------------------------"
echo ""
echo "---------------------- CARGO -------------------------"
cargo install-update -a
echo "---------------------- /CARGO ------------------------"
echo ""
echo "---------------------- FLATPAK -----------------------"
flatpak update
sudo flatpak update
echo "---------------------- /FLATPAK ----------------------"
echo ""
echo "---------------------- SNAP --------------------------"
sudo snap refresh
echo "---------------------- /SNAP -------------------------"
echo ""
