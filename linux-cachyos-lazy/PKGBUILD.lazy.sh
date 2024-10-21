#!/bin/bash
# Kernel build script.

# Exit immediately on error.
set -e

############################################################
# Build options for the lazy variant.
############################################################

# Enable CachyOS config
export _cachy_config="y"

# Tweak kernel options prior to a build via nconfig
export _makenconfig=""

# Tweak kernel options prior to a build via menuconfig
export _makemenuconfig=""

# Tweak kernel options prior to a build via xconfig
export _makexconfig=""

# Tweak kernel options prior to a build via gconfig
export _makegconfig=""

# NUMA is optimized for multi-socket motherboards
# It seems that in 2023 this is not really a huge regression anymore
export _NUMAdisable=""

# Compile ONLY used modules to VASTLY reduce the number of modules built
# and the build time.
export _localmodcfg=""
export _localmodcfg_path="$HOME/.config/modprobed.db"

# Use the current kernel's .config file
export _use_current=""

# Enable KBUILD_CFLAGS -O3
export _cc_harder="y"

# Enable TCP_CONG_BBR3
export _tcp_bbr3="y"

# Running tick rate { 1000, 800, 600, 500 }
# 1000Hz = 2.0ms, 800Hz = 2.5ms, 600Hz = 1.6(6)ms, 500Hz = 2.0ms
export _HZ_ticks="600"

# Select tickless { perodic, idle, full }
export _tickrate="full"

# Select preempt { server, voluntary, full, lazy, laziest }
export _preempt="lazy"

# Set NR_CPUS, leave at 512 for better performance
export _nr_cpus="512"

# Select performance governor
export _per_gov=""

# Transparent Hugepages { always, madvise }
export _hugepage="always"

# Use automatic CPU optimization
export _use_auto_optimization="y"

# Select CPU compiler optimization (overrides _use_auto_optimization)
# { native_amd, native_intel, zen, zen2, zen3, zen4,
#   generic, generic_v1, generic_v2, generic_v3, generic_v4,
#   sandybridge, ivybridge, haswell, icelake, tigerlake, alderlake }
export _processor_opt=""

############################################################
# Non-configurable parameters. Do not change.
############################################################

# Build Berkeley Packet Filter (BPF) support (default)
export _nobpf=""

# Never prebuild the NVIDIA modules for custom kernels.
# Rather, let DKMS handle it for future proof.
# Support removed in PKGBUILD.lazy.
export _build_nvidia=""
export _build_nvidia_open=""

# Overwrite PKGBUILD if it exists
cp PKGBUILD.lazy PKGBUILD

# Build kernel lazy and lazy-headers packages
makepkg -scf --cleanbuild --skipinteg

