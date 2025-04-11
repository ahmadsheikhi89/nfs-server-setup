#!/bin/bash

################################################################################
# 🐧 NFS Server Setup Script for Rocky Linux 9.5
# 👨‍💻 Author: Ahmad Sheikhi
# 🌐 GitHub: https://github.com/ahmadsheikhi89/nfs-server-setup
# 📜 Description:
#   This script guides you step-by-step to install and configure an NFS server
#   in an enterprise-grade environment with LVM, DNS, firewall, logging,
#   and basic hardening policies.
################################################################################

# 🎯 ==== VARIABLES ====
HOSTNAME="nfs-server01"
DOMAIN="corp.example.com"
FQDN="$HOSTNAME.$DOMAIN"
IPADDR="10.10.20.10"
DNS_SERVERS=("10.10.10.10" "10.10.10.11")

DISK_DEVICE="/dev/sdb"
VG_NAME="vgnfsdata"
LV_NAME="lvnfsdata"
MOUNT_POINT="/nfsdata"
LV_SIZE="100G"

APP_USER="utapp"
APP_GROUP="appuser"
APP_UID=35463
APP_GID=35318
EXTRA_GROUP=35000

EXPORT_OPTIONS="rw,sync,no_root_squash"
ALLOWED_CLIENTS=("10.10.20.21" "10.10.20.22")

SYSLOG_SERVER1="syslog1.corp.example.com"
SYSLOG_SERVER2="10.10.10.200"

# 🧰 ==== FUNCTIONS ====
function pause() {
  read -rp $'\n🚦 Press enter to continue...'
}

function info() {
  echo -e "\n\033[1;34mℹ️  [INFO]\033[0m $1"
}

function warn() {
  echo -e "\n\033[1;33m⚠️  [WARN]\033[0m $1"
}

function error_exit() {
  echo -e "\n\033[1;31m❌ [ERROR]\033[0m $1"
  exit 1
}

# 🏷️ ==== STEP 1: Set Hostname ====
info "Setting hostname to $FQDN"
hostnamectl set-hostname "$FQDN"

# 🗒️ ==== STEP 2: Configure /etc/hosts ====
info "Updating /etc/hosts"
echo -e "$IPADDR\t$FQDN\t$HOSTNAME" >> /etc/hosts

# 🌐 ==== STEP 3: Configure resolv.conf ====
info "Setting DNS servers"
chattr -i /etc/resolv.conf || true
{
  echo "search $DOMAIN"
  for dns in "${DNS_SERVERS[@]}"; do
    echo "nameserver $dns"
  done
} > /etc/resolv.conf
chattr +i /etc/resolv.conf

pause

# 📦 ==== STEP 4: Install NFS packages ====
info "Installing NFS server packages"
dnf install -y nfs-utils || error_exit "Failed to install NFS packages."

# 🧩 ==== STEP 5: Enable NFS Services ====
info "Enabling and starting NFS services"
systemctl enable --now nfs-server rpcbind || error_exit "Failed to enable NFS services."
systemctl status nfs-server

pause

# 💽 ==== STEP 6: Setup LVM ====
info "Creating LVM volume on $DISK_DEVICE"
pvcreate "$DISK_DEVICE"
vgcreate "$VG_NAME" "$DISK_DEVICE"
lvcreate -L "$LV_SIZE" -n "$LV_NAME" "$VG_NAME"
mkfs.xfs "/dev/$VG_NAME/$LV_NAME"

mkdir -p "$MOUNT_POINT"
echo "/dev/$VG_NAME/$LV_NAME $MOUNT_POINT xfs defaults 0 0" >> /etc/fstab
mount -a && df -h "$MOUNT_POINT"

pause

# 📡 ==== STEP 7: Create NFS Exports ====
info "Configuring NFS exports"
> /etc/exports
for client in "${ALLOWED_CLIENTS[@]}"; do
  echo "$MOUNT_POINT $client($EXPORT_OPTIONS)" >> /etc/exports
  info "Added export for $client"
done

exportfs -rav
showmount -e

pause

# 🔥 ==== STEP 8: Configure Firewall ====
info "Configuring firewall for NFS access"
firewall-cmd --permanent --add-service=nfs
firewall-cmd --permanent --add-service=rpc-bind
firewall-cmd --permanent --add-service=mountd
firewall-cmd --reload

pause

# 👥 ==== STEP 9: User & Group Setup ====
info "Creating user and group: $APP_USER:$APP_GROUP"
groupadd -g "$APP_GID" "$APP_GROUP"
useradd -u "$APP_UID" -g "$APP_GID" -G "$EXTRA_GROUP" -m -d "$MOUNT_POINT" -s /bin/bash "$APP_USER"

chown -R "$APP_USER:$APP_GROUP" "$MOUNT_POINT"

pause

# 📝 ==== STEP 10: Configure Rsyslog for Central Logging ====
info "Configuring rsyslog to send logs to central servers"
cp /etc/rsyslog.conf /etc/rsyslog.conf.bak
cat <<EOF >> /etc/rsyslog.conf

# Central syslog forwarding (Example for enterprise logging)
*.* @$SYSLOG_SERVER1
*.* @$SYSLOG_SERVER2
EOF

systemctl restart rsyslog
systemctl enable rsyslog

pause

# 🔐 ==== STEP 11: Basic Hardening ====
info "Applying basic security hardening"
# Disable root SSH login
sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl reload sshd

# Set SELinux to enforcing
sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config
setenforce 1

pause

info "🎉 NFS Server setup completed successfully!"
echo -e "\n\033[1;32m[✔]\033[0m You can now mount $FQDN:$MOUNT_POINT from allowed clients."
