# kvm-cloud-init-automation

![License](https://img.shields.io/badge/License-MIT-blue)
![Bash](https://img.shields.io/badge/Script-Bash-121011?logo=gnu-bash&logoColor=white)
![YAML](https://img.shields.io/badge/Config-YAML-CB171E?logo=yaml&logoColor=white)

An automated utility to generate **Cloud-Init Seed ISOs** (cidata) for KVM/libvirt virtual machines. This tool streamlines the process of injecting configuration and networking logic into "NoCloud" datasources.

<img width="1280" height="720" alt="Untitled (1600 x 840 px)(1)" src="https://github.com/user-attachments/assets/30a90c73-1f4b-4f22-af30-e7997b33e2a6" />


## Features
- **Tailscale Integration**: Automatically joins your tailnet on first boot.
- **Dynamic Networking**: Renames hostnames based on assigned Tailscale IPs.
- **Auto-Reboot**: Reboots the VM once configuration is successfully applied.

## 🧹 Template VM Preparation

Before converting your Ubuntu VM into a template, run these commands inside the VM to reset its identity (Machine ID, SSH keys, and logs).
Full Cleanup 
```
sudo cloud-init clean
sudo rm -rf /var/lib/cloud/*
sudo truncate -s 0 /etc/machine-id
sudo rm -f /var/lib/dbus/machine-id
sudo rm -f /etc/ssh/ssh_host_*
sudo truncate -s 0 /var/log/*.log
history -c && rm -f ~/.bash_history
sudo hostnamectl set-hostname localhost
sudo rm -f /etc/netplan/*.yaml
sudo rm -rf /tmp/* /var/tmp/*
sudo poweroff
```

## 🛠 Prerequisites to run script

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
## Output Images of Project

1 ) Generate the Seed ISO
  <img width="2032" height="1110" alt="Screenshot 2026-04-15 at 9 20 14 PM" src="https://github.com/user-attachments/assets/50aa0668-727a-4265-b23a-d7c30692fd87" />

2 ) Attach to Virtual Machine
  <img width="2032" height="1110" alt="Screenshot 2026-04-15 at 9 23 16 PM" src="https://github.com/user-attachments/assets/6193a4b3-b142-4d11-8308-a677459f7b0a" />

3 ) Verifying Cloud-Init Success
  <img width="2032" height="1095" alt="Screenshot 2026-04-15 at 10 22 43 PM" src="https://github.com/user-attachments/assets/d7c7d850-cb7b-4a17-a09a-859dae05642a" />
