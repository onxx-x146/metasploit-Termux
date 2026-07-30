# *🛡️ Metasploit Termux Installer* 

[![Version](https://img.shields.io/badge/version-6.4-blue)](#)
[![Termux](https://img.shields.io/badge/Termux-Android-green)](#)
[![License](https://img.shields.io/badge/license-MIT-red)](#)

> **A one‑click installer for Metasploit Framework on Termux** – with automatic hiding and write‑protection of the installation folder, so no one else can tamper with it.

---

## ✨ Features

- ✅ **Fully automated** – installs all dependencies, Ruby gems, and the framework itself.
- 🔒 **Hidden installation** – Metasploit goes into `$PREFIX/opt/.metasploit-framework` (dot folder) – invisible in normal `ls`.
- 🛡️ **Immutable protection** – uses `chattr +i` (if supported) to prevent any changes, even by root.
- 🔐 **Restrictive permissions** – only the owner (you) can modify the files; others can only read/execute.
- 🎨 **Beautiful ASCII banner** – shows the Metasploit logo in bold red on startup.
- ⚡ **Lightweight** – clones only the latest commit (depth=1) to save bandwidth and time.
- 📦 **Includes all tools** – `msfconsole`, `msfvenom`, `msfrpcd` are symlinked to your `$PREFIX/bin`.

---

## 📋 Requirements

- Android device with **Termux** installed (from F‑Droid or GitHub, **not** Play Store).
- At least **2 GB** free storage.
- Stable internet connection.

---

## 🚀 Installation

Open Termux and run the following commands:

```bash
git clone https://github.com/onxx-x146/Metasploit-Termux.git
cd main.sh
chmod +x main.sh
bash main.sh
