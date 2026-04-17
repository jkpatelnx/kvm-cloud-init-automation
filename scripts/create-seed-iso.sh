#!/bin/bash

####################################################
# create-seed-iso.sh (Interactive Version)
####################################################

set -e

# 1. Ask for VM Name interactively
read -p "👉 Enter VM Name: " VM_NAME
if [ -z "$VM_NAME" ]; then
  echo "❌ Error: VM Name cannot be empty."
  exit 1
fi

# 2. Ask for Tailscale Key interactively (hidden input)
read -sp "👉 Enter Tailscale Auth Key: " TS_KEY
echo "" # Just a newline for cleanliness
if [ -z "$TS_KEY" ]; then
  echo "❌ Error: Auth Key cannot be empty."
  exit 1
fi

WORKDIR="/tmp/seed-${VM_NAME}"
ISO_NAME="seed-${VM_NAME}.iso"
DEST="/var/lib/libvirt/images"

echo "👉 Preparing working directory..."
mkdir -p "$WORKDIR"
cd "$WORKDIR"

####################################################
# Create meta-data
####################################################

cat > meta-data <<EOF
instance-id: ${VM_NAME}-$(date +%s)
local-hostname: ${VM_NAME}
EOF

####################################################
# Create user-data
# Note: We use 'EOF' (quoted) but pass the TS_KEY variable in
####################################################

cat > user-data <<EOF
#cloud-config

package_update: true

packages:
  - qemu-guest-agent
  - curl

runcmd:
  - systemctl enable --now qemu-guest-agent
  - |
    # Install Tailscale
    curl -fsSL https://tailscale.com/install.sh | sh

    # Authenticate with Tailscale (using your input key)
    tailscale up --authkey=${TS_KEY}

    # Loop to wait for IP and set hostname
    for i in \$(seq 1 20); do
      TS_IP=\$(ip -4 addr show tailscale0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
      if [ -n "\$TS_IP" ]; then
        DASHED_IP=\$(echo "\$TS_IP" | sed 's/\./-/g')
        hostnamectl set-hostname "ip-\$DASHED_IP"
        echo "\$TS_IP" > /root/tailscale-ip.txt
        break
      fi
      sleep 2
    done

# 3. Add auto-reboot after everything is finished
power_state:
  mode: reboot
  message: "Cloud-init complete. Rebooting to apply hostname and network changes."
  timeout: 10
  condition: True
EOF

####################################################
# Create seed ISO
####################################################

echo "👉 Creating seed ISO..."
xorriso -as mkisofs \
  -output "$ISO_NAME" \
  -volid cidata \
  -joliet -rock \
  user-data meta-data

# Move and set permissions
echo "👉 Moving ISO to $DEST..."
sudo mv "$ISO_NAME" "$DEST/"
sudo chown qemu:qemu "$DEST/$ISO_NAME"
sudo chmod 644 "$DEST/$ISO_NAME"

echo "✅ Success! Seed ISO created: $DEST/$ISO_NAME"
