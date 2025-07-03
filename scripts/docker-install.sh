#!/bin/bash

if [ "$(whoami)" != "root" ]; then
    echo "[SCRIPT] Run this script by the root user"
    exit 1
fi

echo "[SCRIPT] Updating repositories..."
apt-get update > /dev/null
if [ ! -f /etc/apt/keyrings/docker.asc ]; then
    echo "[SCRIPT] Adding Docker certificate..."
    apt-get install -y ca-certificates curl > /dev/null
    if [ $? -eq 0 ]; then
        echo "[SCRIPT] ca-certificates and curl packages installed (or verified that they already exist)"
    else
        echo "[SCRIPT] Error during installation of ca-certificates and curl packages. Aborting"
        exit 1
    fi
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    if [ $? -ne 0 ]; then
        echo "[SCRIPT] Error during downloading Docker certificate file. Aborting"
        exit 1
    fi
    chmod a+r /etc/apt/keyrings/docker.asc
    echo "[SCRIPT] Added Docker certificate"
else
        echo "[SCRIPT] Docker certificate is already added. Skip"
fi

if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
        echo "[SCRIPT] Adding Docker repository..."
        echo \
              "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
              $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
              tee /etc/apt/sources.list.d/docker.list > /dev/null
        apt-get update > /dev/null
        if [ $? -ne 0 ]; then
            echo "[SCRIPT] Error during adding Docker repository. Aborting"
            exit 1
        fi
        echo "[SCRIPT] Added Docker repository"
else
    echo "[SCRIPT] Docker repo is already added. Skip"
fi

echo "[SCRIPT] Installing Docker..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin > /dev/null
if [ $? -ne 0 ]; then
    echo "[SCRIPT] Error during installation of Docker packages. Aborting"
    exit 1
fi
echo "[SCRIPT] Docker packages installed (or verified that they already exist)"

systemctl disable --now docker.service docker.socket > /dev/null
if [ $? -ne 0 ]; then
    echo "[SCRIPT] Error during system-wide Docker unit shutdown. Aborting"
    exit 1
fi
echo "[SCRIPT] System-wide Docker disabled (or verified that it's already disabled)"

if [ -f /var/run/docker.sock ]; then
        rm /var/run/docker.sock
        echo "[SCRIPT] System-wide docker socket removed"
else
        echo "[SCRIPT] System-wide docker socket is not exist. Skip"
fi

apt-get install -y docker-ce-rootless-extras > /dev/null
if [ $? -ne 0 ]; then
    echo "[SCRIPT] Error during installation of docker-ce-rootless-extras package. Aborting"
    exit 1
fi
echo "[SCRIPT] docker-ce-rootless-extras package installed (or verified that it already exists)"

apt-get install -y uidmap > /dev/null
if [ $? -ne 0 ]; then
    echo "[SCRIPT] Error during installation of uidmap package. Aborting"
    exit 1
fi
echo "[SCRIPT] uidmap package installed (or verified that it already exists)"

echo "nf_tables" | tee /etc/modules-load.d/nf_tables.conf
if [ $? -ne 0 ]; then
    echo "[SCRIPT] Error during adding nf_tables module to load on boot. Aborting"
    exit 1
fi

if lsmod | grep -q "nf_tables"; then
    echo "[SCRIPT] nf_tables module already loaded. Skip"
else
    modprobe nf_tables
    if [ $? -ne 0 ]; then
        echo "[SCRIPT] Error during loading nf_tables module. Aborting"
    exit 1
    else
        echo "[SCRIPT] nf_tables module loaded"
    fi
fi

echo "[SCRIPT] Success. Run docker-rootless.sh to activate rootless Docker"