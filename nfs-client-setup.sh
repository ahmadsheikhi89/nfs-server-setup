#!/bin/bash

################################################################################
# 📦 NFS Client Setup Script
# For Rocky Linux 9.5 / RHEL / CentOS
# Author: Ahmad Sheikhi
################################################################################

# Configuration
NFS_SERVER="nfs-server01.corp.example.com"
NFS_SHARE="/nfsdata"
MOUNT_POINT="/mnt/nfsdata"

echo "🔧 Installing required packages..."
dnf install -y nfs-utils || { echo "❌ Failed to install nfs-utils"; exit 1; }

echo "📁 Creating mount point at $MOUNT_POINT..."
mkdir -p "$MOUNT_POINT"

echo "📡 Mounting NFS share..."
mount -o rw,sync,noatime "${NFS_SERVER}:${NFS_SHARE}" "$MOUNT_POINT"

if mountpoint -q "$MOUNT_POINT"; then
  echo "✅ Successfully mounted ${NFS_SERVER}:${NFS_SHARE} at $MOUNT_POINT"
else
  echo "❌ Mount failed. Check server IP/FQDN or firewall."
  exit 1
fi

echo "📌 Adding to /etc/fstab for persistent mount..."
echo "${NFS_SERVER}:${NFS_SHARE}  $MOUNT_POINT  nfs  rw,sync,noatime  0  0" >> /etc/fstab

echo "🔐 Enabling SELinux permission for NFS home dirs..."
setsebool -P use_nfs_home_dirs 1

echo "🎉 Client configuration completed!"
