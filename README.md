# 📦 NFS Server Setup for Rocky Linux 9.5

This project provides a clean, professional, and educational Bash script to manually install and configure an **NFS Server** on **Rocky Linux 9.5**.

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
├── README.md                 # Documentation (this file)
├── LICENSE                   # Project license (MIT recommended)
├── .gitignore                # Ignore logs/temp files
└── examples/                 # Sample configurations
    ├── rsyslog.conf.sample
    ├── hosts.sample
    └── resolv.conf.sample
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

---

## 📄 License
MIT — feel free to fork, modify, and use in your organization!

---

## 🤝 Contributions
Pull requests and issues are welcome. Let's improve this together 🚀

