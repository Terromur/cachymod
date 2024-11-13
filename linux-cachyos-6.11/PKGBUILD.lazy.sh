#!/bin/bash
# Kernel build script.

# Exit script immediately on error.
set -e

############################################################
# Build options for the lazy variant.
############################################################

# Run the "trim.sh" script to trim the kernel
# To deselect ~ 1,500 kernel options
export _runtrim_script=""

# Compile ONLY used modules to VASTLY reduce the number of modules built
# and the build time. Refer to the wiki page for more information.
# https://wiki.archlinux.org/index.php/Modprobed-db
#
# Installation:
#    sudo pacman -S modprobed-db
#    sudo modprobed-db store  (creates ~/.config/modprobed-db.conf)
#
# Be sure to run "store" from a stock CachyOS kernel at least once.
# Run subsequently to store any new module(s) to the database.
#    sudo modprobed-db store  (refreshes ~/.config/modprobed.db)
#
export _localmodcfg=""
export _localmodcfg_path="$HOME/.config/modprobed.db"

# Tweak kernel options prior to a build via nconfig or gconfig
export _makenconfig=""
export _makegconfig=""

# NUMA is optimized for multi-socket motherboards
# It seems that in 2023 this is not really a huge regression anymore
export _NUMAdisable=""

# Transparent Hugepages { always, madvise }
export _hugepage="always"

# Running tick rate { 1000, 800, 600, 500 }
# Select 1000 if your machine has less than or equal to 16 CPUs.
# Otherwise, the best value is a mystery. If unsure, select 1000.
export _HZ_ticks="1000"

# Select preemption { voluntary, full, lazy, rt }
# Select "voluntary" for desktop, matching the Clear kernel preemption.
# Select "full" for low-latency desktop, matching the CachyOS kernel preemption.
# Select "lazy" for low-latency desktop, matching the CachyOS RT kernel preemption.
# Select "rt" for real-time preemption, running time-sensitive instruments.
# Kernel suffix is "lazy" for voluntary/full/lazy options; "lazy-rt" for rt.
export _preempt="full"

# Use automatic CPU optimization
export _use_auto_optimization="y"

# Select CPU compiler optimization (overrides _use_auto_optimization)
# { native_amd, native_intel, zen, zen2, zen3, zen4, generic,
#   generic_v1, generic_v2, generic_v3, generic_v4, sandybridge,
#   ivybridge, haswell, skylake, icelake, tigerlake, alderlake }
export _processor_opt=""

# Add extra sources here: opt-in/uncomment for the USB pollrate patch
# Refer to https://github.com/GloriousEggroll/Linux-Pollrate-Patch
# Do not add the pollrate patch unless useful to you.
#export _extra_patch_or_url1="0300-pollrate.patch"
#export _extra_patch_or_url2=""
#export _extra_patch_or_url3=""
#export _extra_patch_or_url4=""
#export _extra_patch_or_url5=""

############################################################
# Build the kernel.
############################################################

# Overwrite PKGBUILD if it exists
cp PKGBUILD.lazy PKGBUILD

# Build kernel lazy and lazy-headers packages
time nice -n 15 makepkg -scf --cleanbuild --skipinteg

