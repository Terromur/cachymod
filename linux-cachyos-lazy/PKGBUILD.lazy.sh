#!/bin/bash

# Add suffix to pkgbase variable in PKGBUILD file
# pkgbase="$pkgbase-lazy"

# Overwrite PKGBUILD if it exists
cp PKGBUILD.lazy PKGBUILD

# Enable CachyOS config
export _cachy_config=y

# Enable KBUILD_CFLAGS -O3
export _cc_harder=y

# Enable TCP_CONG_BBR3
export _tcp_bbr3=y

# Running tick rate
export _HZ_ticks=600

# Select tickless
export _tickrate=full

# Select preempt
export _preempt=lazy

# Set NR_CPUS
export _nr_cpus=512

# Transparent Hugepages
export _hugepage=always

# Apply automatic CPU Optimization
export _use_auto_optimization=y

# Enable LTO
export _use_llvm_lto=none

# Never prebuild the NVIDIA modules for custom kernels.
# Rather, let DKMS handle it for future proof.
export _build_nvidia=""
export _build_nvidia_open=""

# Build kernel packages lazy and lazy-headers.
makepkg -scf --cleanbuild --skipinteg

