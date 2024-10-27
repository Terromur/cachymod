#!/bin/bash
# Kernel build script.

# Exit script immediately on error.
set -e

############################################################
# Build options for the lazy variant.
############################################################

# Compile ONLY used modules to VASTLY reduce the number of modules built
# and the build time. Refer to the wiki page for more information.
# https://wiki.archlinux.org/index.php/Modprobed-db
export _localmodcfg=""
export _localmodcfg_path="$HOME/.config/modprobed.db"

# Tweak kernel options prior to a build via nconfig or gconfig
export _makenconfig=""
export _makegconfig=""

# Running tick rate { 1000, 800, 600, 500 }
# Select 1000 if your machine has less than or equal to 16 CPUs.
# Otherwise, the best value is a mystery. If unsure, select 1000.
export _HZ_ticks="1000"

# Select preempt { full, lazy, realtime }
# Select "full" for low-latency or "lazy" if you prefer throughput. 
# Select "realtime" if running time-sensitive instruments.
# Most often "full" preemption is sufficient.
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
nice -n 6 makepkg -scf --cleanbuild --skipinteg

