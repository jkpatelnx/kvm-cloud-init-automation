# KVM Seed ISO Generator

![License](https://img.shields.io/badge/License-MIT-blue)

An automated utility to generate **Cloud-Init Seed ISOs** (cidata) for KVM/libvirt virtual machines. This tool streamlines the process of injecting configuration and networking logic into "NoCloud" datasources.

## Features
- **Tailscale Integration**: Automatically joins your tailnet on first boot.
- **Dynamic Networking**: Renames hostnames based on assigned Tailscale IPs.
- **Auto-Reboot**: Reboots the VM once configuration is successfully applied.

## 🛠 Prerequisites

Before running the script, ensure your host system has the necessary tools installed:

Ubuntu / Debian : `sudo apt update && sudo apt install xorriso curl -y`

RHEL/CentOS : `sudo dnf install xorriso curl -y`

## Usage
1. Make the script executable: `chmod +x scripts/create-seed-iso.sh`
2. Run the generator: `./scripts/create-seed-iso.sh`
3. Enter your VM name and Tailscale key when prompted.

## Repository Structure

```
kvm-cloud-init-automation/
│
├── scripts/              # automation scripts
│   └── create-seed-iso.sh
│
├── templates/            # cloud-init templates
│   ├── meta-data.example.yaml
│   └── user-data.example.yaml
│
├── README.md
├── LICENSE
└── .gitignore
```
