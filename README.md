![Banner](https://raw.githubusercontent.com/ahmadsheikhi89/nfs-server-setup/main/banner.png)

# 📦 NFS Server Setup for Rocky Linux 9.5 (NFSv3)

![Shell Script](https://img.shields.io/badge/shell-bash-blue?logo=gnu-bash)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![OS: Rocky Linux 9.5](https://img.shields.io/badge/OS-Rocky%20Linux%209.5-00bfff?logo=linux)
![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)

> 📌 **Note:** This project is based on **NFSv3**. If you are looking for a modern and more secure configuration with **NFSv4**, check out the [NFSv4 version here](https://github.com/ahmadsheikhi89/nfs-server-setup-v4) *(coming soon)*.

---

## 🔄 NFSv3 vs NFSv4: Key Differences

| Feature                      | NFSv3                          | NFSv4                            |
|-----------------------------|--------------------------------|----------------------------------|
| 🔐 Security & Identity       | Basic (UID/GID only)           | Supports strong identity mapping (idmapd) |
| 🔥 Firewall simplicity       | Needs multiple ports open      | Single port (TCP 2049)           |
| 📁 Mount behavior            | Absolute paths per export      | Relative paths under export root (fsid=0) |
| 🧩 Extra daemons             | Needs `rpcbind`, `mountd`      | Doesn't require mountd           |
| 🔐 SELinux interaction       | May need more exceptions       | Cleaner integration with SELinux |
| 📡 Protocol type             | Stateless                      | Stateful with locking and delegation |

> ✅ NFSv3 is suitable for simpler or mixed environments with older clients.
> ✅ NFSv4 is recommended for modern, secure, and firewall-restricted setups.

---

## ✍️ Author
**Ahmad Sheikhi**  
🔗 [GitHub Profile](https://github.com/ahmadsheikhi89)

---

## 📜 Features
- LVM-based disk setup
- NFS server installation and export configuration
- DNS and hostname configuration
- rsyslog integration for centralized logging
- Firewall and SELinux configuration
- User and group creation
- Step-by-step guided execution with logs and prompts
- Emoji-enhanced terminal output 😎

---

## 📂 Repository Structure
```bash
nfs-server-setup/
├── nfs-setup.sh              # Main interactive Bash script
├── nfs-client-setup.sh       # Optional NFS client-side automation
├── README.md                 # Documentation (this file)
├── LICENSE                   # Project license (MIT recommended)
├── .gitignore                # Ignore logs/temp files
├── hosts.sample              # Sample hosts file
├── resolv.conf.sample        # Sample DNS resolver file
├── rsyslog.conf.sample       # Sample rsyslog config
```

---

## ⚙️ Prerequisites
- Rocky Linux 9.5
- Root or sudo privileges
- A second disk (e.g. `/dev/sdb`) for NFS data

---

## 🚀 How to Use
Clone the repository:
```bash
git clone https://github.com/ahmadsheikhi89/nfs-server-setup.git
cd nfs-server-setup
chmod +x nfs-setup.sh
sudo ./nfs-setup.sh
```
> You'll be prompted at each step. It's designed to be educational and interactive.

> 🛠️ **Note:** Please customize the script to match your organization's infrastructure and security policies before using it in production environments.

---

## 📥 Example Output
```bash
ℹ️  [INFO] Setting hostname to nfs-server01.corp.example.com
ℹ️  [INFO] Installing NFS server packages
ℹ️  [INFO] Configuring NFS exports
ℹ️  [INFO] Creating LVM volume on /dev/sdb
✔️  You can now mount nfs-server01:/nfsdata from allowed clients.
```

---

## 📦 Client Configuration (Mounting NFS)
To mount the exported NFS share on a client (e.g. Rocky Linux, RHEL, or CentOS):

### 📌 Option A: Manual Configuration

**Step 1: Install required packages**
```bash
sudo dnf install -y nfs-utils
```

**Step 2: Create the mount directory**
```bash
sudo mkdir -p /mnt/nfsdata
```

**Step 3: Mount the share**
```bash
sudo mount -o rw,sync,noatime nfs-server01.corp.example.com:/nfsdata /mnt/nfsdata
```

**Make it persistent:**
```bash
echo "nfs-server01.corp.example.com:/nfsdata  /mnt/nfsdata  nfs  rw,sync,noatime  0  0" | sudo tee -a /etc/fstab
```

**SELinux adjustment (if enabled):**
```bash
sudo setsebool -P use_nfs_home_dirs 1
```

### 📌 Option B: Use Provided Script
You can automate this process using the included script:
```bash
chmod +x nfs-client-setup.sh
sudo ./nfs-client-setup.sh
```
This script will:
- Install required packages
- Create the mount point
- Mount the remote NFS share
- Add it to `/etc/fstab`
- Configure SELinux for NFS

---

## ✅ Recommended Configuration:
- Ensure DNS resolves the NFS server FQDN correctly.
- Make sure the NFS ports are open on the client.
- SELinux should allow NFS mounts (`setsebool -P use_nfs_home_dirs 1`).
- Avoid mounting with `no_root_squash` unless needed.

---

## 🧠 Educational Value
This script is meant for:
- Linux sysadmins looking to understand NFS setup deeply
- Educational labs
- Organizations wanting to build infrastructure step-by-step

---

## 🔒 Security Notes
- The script disables root login via SSH.
- SELinux is enforced.
- All modifications are logged and confirmed.
- Example user `utapp` is created with custom UID/GID.
- Clients must be explicitly allowed in `/etc/exports`.

---

## 📄 License
MIT — feel free to fork, modify, and use in your organization!

---

## 🤝 Contributions
Pull requests and issues are welcome. Let's improve this together 🚀

