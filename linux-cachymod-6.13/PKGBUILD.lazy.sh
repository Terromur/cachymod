#!/bin/bash
# Kernel build script.

# Exit script immediately on error.
set -e

###############################################################################
# Build options. Unless selections given, answer "yes/y/1", "no/n/0" or "".
###############################################################################

# The default is patching the kernel with the complete BORE CPU scheduler.
# If you prefer EEVDF, only the BORE optimal base slice logic is applied.
# The kernel will be tagged "eevdf" or "bore".
export _prefer_eevdf=""

# Run the "trim.sh" script to trim the kernel
# To deselect ~ 1,500 kernel options
export _runtrim_script=""

# Disable DEBUG_INFO related knobs for more kernel trimming.
# BPF and SCX will not work, used by all sorts of stuff including firewall.
# This requires disabling the ananicy-cpp service or will segfault.
# i.e sudo systemctl disable --now ananicy-cpp.service
# Hence, if you do not use these things, want to save time building,
# and unlikely to decode a stack trace later.
# This option is ignored if selecting _build_debug package below.
export _disable_debug_info=""

# Enable sched_ext (SCX) scheduler (overrides _disable_debug_info).
# The _disable_debug_info build option is ignored.
# This option is ignored for real-time preemption.
export _enable_sched_ext=""

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

# Running tick rate { 1000, 800, 750, 600, 500 }
# Select 1000 if your machine has less than or equal to 16 CPUs.
# Select 800 if you want a balance between latency and performance,
# with more focus on latency. Otherwise, the best value is a mystery.
# If unsure, select 1000.
export _HZ_ticks="1000"

# Select tickless type { full, idle }
# Full tickless can give higher performances in various cases but, depending on
# hardware, lower consistency. Idle (without rcu_nocb_cpu) may reduce stutters.
export _ticktype="full"

# Select preemption { dynamic, voluntary, full, lazy, rt }
# Select "dynamic" for runtime selectable none, voluntary, (full), or lazy.
# Select "voluntary" for desktop, matching the Clear kernel preemption.
# Select "full" for low-latency desktop, matching the CachyOS kernel preemption.
# Select "lazy" for low-latency desktop, matching the CachyOS RT kernel preemption.
# Select "rt" for real-time preemption, running time-sensitive instruments.
# The _enable_sched_ext build option is ignored for real-time preemption.
export _preempt="full"

# Use automatic CPU optimization
export _use_auto_optimization="y"

# Select CPU compiler optimization (overrides _use_auto_optimization)
# { native_amd, native_intel, zen, zen2, zen3, zen4, generic,
#   generic_v1, generic_v2, generic_v3, generic_v4, core2, sandybridge,
#   ivybridge, haswell, broadwell, skylake, skylakex, icelake, tigerlake,
#   sapphirerapids, alderlake, raptorlake, meteorlake, emeraldrapids }
export _processor_opt=""

# Select build type { full, thin, polly, gcc }
# full:  Build the kernel with clang (full-LTO + polly), suffix "-lto"
#        Uses 1 thread for linking, slow and uses more memory (>16GB),
#        theoretically with the highest performance gains
# thin:  Build the kernel with clang (thin-LTO + polly), suffix "-lto"
#        Uses multiple threads, faster and lesser memory consumption,
#        possibly lower runtime performance than full
# polly: Build kernel with clang polyhedral loop optimizer, suffix "-polly"
# gcc:   Build kernel with gcc, suffix "-gcc"
export _buildtype="polly"

# Add extra sources here: opt-in/uncomment for the USB pollrate patch
# Refer to https://github.com/GloriousEggroll/Linux-Pollrate-Patch
# Do not add the pollrate patch unless useful to you.
#export _extra_patch_or_url1="1010-usb-pollrate.patch"
#export _extra_patch_or_url2="1020-drm-amdgpu-always-allocate-cleared.patch"
#export _extra_patch_or_url3="1030-amdgpu-fix-suspend-resume-issues.patch"
#export _extra_patch_or_url4="1040-intel-idle.patch"
#export _extra_patch_or_url5="1050-cpuidle-Prefer-teo.patch"
#export _extra_patch_or_url6="1060-misc-fixes.patch"
#export _extra_patch_or_url7="1070-optimise-ldflags.patch"
#export _extra_patch_or_url8="ALSA-Align-the-syntax-of-iov_iter-helpers-with-standard-ones.diff"
#export _extra_patch_or_url9=""

# Build a debug package with non-stripped vmlinux
export _build_debug="${_build_debug-}"

# Enable AUTOFDO_CLANG for the first compilation to create a kernel,
# which can be used for profiling
# See wiki: https://cachyos.org/blog/2411-kernel-autofdo/
# 1. Compile a kernel with _build_debug="y" and _autofdo="y"
# 2. Boot the kernel in QEMU or on your system, see Workload
# 3. Profile the kernel and convert the profile,
#    see Generating the Profile for AutoFDO
# 4. Put the profile into the sourcedir
# 5. Run kernel build again with the _autofdo_profile_name
#    path to profile specified
export _autofdo="${_autofdo-}"

# Name for the AutoFDO profile
export _autofdo_profile_name="${_autofdo_profile_name-}"

###############################################################################
# Build the kernel.
###############################################################################

# Overwrite PKGBUILD if it exists
cp PKGBUILD.lazy PKGBUILD

# Build kernel lazy and lazy-headers packages
time nice -n 15 makepkg -scf --cleanbuild --skipinteg || exit 1

