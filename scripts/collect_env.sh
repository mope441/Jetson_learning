#!/usr/bin/env bash
set -Eeuo pipefail

OUTPUT="${1:-results/week01/environment.txt}"
mkdir -p "$(dirname "$OUTPUT")"

{
    echo "===== Timestamp ====="
    date -Is

    echo
    echo "===== Jetson BSP ====="
    cat /etc/nv_tegra_release 2>/dev/null || true

    echo
    echo "===== Operating System ====="
    cat /etc/os-release
    uname -a

    echo
    echo "===== JetPack Package ====="
    dpkg-query -W nvidia-jetpack 2>/dev/null || true

    echo
    echo "===== CUDA ====="
    nvcc --version 2>/dev/null || true

    echo
    echo "===== TensorRT ====="
    trtexec --version 2>/dev/null \
        || /usr/src/tensorrt/bin/trtexec --version 2>/dev/null \
        || true

    echo
    echo "===== Python ====="
    python3 --version
    pip3 --version 2>/dev/null || true

    echo
    echo "===== Docker ====="
    docker --version 2>/dev/null || true

    echo
    echo "===== Storage ====="
    lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINTS,MODEL
    df -hT

    echo
    echo "===== Power Mode ====="
    sudo nvpmodel -q --verbose 2>/dev/null || true

    echo
    echo "===== Network ====="
    ip -brief address
} | tee "$OUTPUT"