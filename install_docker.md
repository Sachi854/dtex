# Install Docker  

Docs is [here](https://docs.docker.com/docker-for-windows/install-windows-home/)

# Contesnts

- [Install Docker](#install-docker)
- [Contesnts](#contesnts)
- [Linux](#linux)
  - [Advance preparation](#advance-preparation)
    - [1. UEFIからCPU仮想化支援機能を有効にする](#1-uefiからcpu仮想化支援機能を有効にする)
  - [Install](#install)
  - [Initialize](#initialize)
- [Windows](#windows)
  - [Advance Preparation](#advance-preparation-1)
    - [1. UEFIからCPU仮想化支援機能を有効にする](#1-uefiからcpu仮想化支援機能を有効にする-1)
    - [2. WSL2を有効にする](#2-wsl2を有効にする)
    - [3. Hyper-Vを有効にする](#3-hyper-vを有効にする)
  - [Install](#install-1)
  - [Initialize](#initialize-1)

# Linux 

## Advance preparation

### 1. UEFIからCPU仮想化支援機能を有効にする

VT-xもしくはAMD-Vを有効にする

## Install

[ここ](https://docs.docker.com/engine/install/)みて各ディストリビューションごとに作業する.  

---

Ubuntuのみやり方を説明する  

```bash
# Install and Update
sudo apt remove docker docker-engine docker.io containerd runc
sudo apt update
sudo apt upgrade
sudo apt install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Install Docker Engine
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io 
```

## Initialize

[ここ](https://docs.docker.com/engine/security/rootless/)みてルートレスモードの設定をする.  

---

Ubuntuのみやり方を説明する  

```bash
# Install uidmap
sudo apt update
sudo apt install uidmap

# Install root less mode
curl -fsSL https://get.docker.com/rootless | sh

# Enable demon
systemctl --user enable docker
sudo loginctl enable-linger $(whoami)
```

# Windows

## Advance Preparation

### 1. UEFIからCPU仮想化支援機能を有効にする

VT-xもしくはAMD-Vを有効にする

### 2. WSL2を有効にする

PowerShellを管理者権限で起動し以下コマンドでWSLを有効化  

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

PowerShellを管理者権限で起動し以下コマンドで仮想マシンプラットフォームを有効化  

```powershell
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

WSL2用に[Linux kernel update package](https://docs.microsoft.com/windows/wsl/wsl2-kernel)をインストールする

インストールしたらPowerShellに以下コマンドでWSL2を有効化  

```powershell
wsl --set-default-version 2
```

### 3. Hyper-Vを有効にする

(やらなくていい)

Hyper-Vを有効化

```powershell
DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V
```

Hyper-Vを自動起動するように設定

```powershell
bcdedit /set hypervisorlaunchtype auto
```

## Install

[ここ](https://hub.docker.com/editions/community/docker-ce-desktop-windows/)からダウンロードしてインストール. WSL2を使用するにチェックを入れる

## Initialize

Setting -> General -> Start Docker Desktop when you log in を有効にする  

v20.10.2だとバグがあり Setting -> Docker Engine の中身を書き換える必要がある．"buildkit": true を false にしないと build できないので注意するように.  

```json
{
  "registry-mirrors": [],
  "insecure-registries": [],
  "debug": false,
  "experimental": false,
  "features": {
    "buildkit": false
  }
}
```

