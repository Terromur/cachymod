# CachyMod

Run a 6.11 kernel with lazy preemption capability on [CachyOS](https://cachyos.org/).

If running NVIDIA graphics, first switch to DKMS for future proof CachyOS
updating the NVIDIA stack to a later release.

```bash
# Obtain a list of NVIDIA kernel modules.
pacman -Q | awk '/^linux-cachyos-.*nvidia/ { print $1 }'

# Remove any prebuilt NVIDIA kernel modules.
sudo pacman -Rsn linux-cachyos-nvidia
sudo pacman -Rsn linux-cachyos-nvidia-open

# Install NVIDIA sources for DKMS (choose one).
sudo pacman -S nvidia-dkms
sudo pacman -S nvidia-open-dkms
```

## Building and Installation

Copy the `linux-cachyos-lazy` folder to a work area with ample storage space,
and change directory. Adjust build options in `PKGBUILD.lazy.sh`.
Select `_preempt=realtime` for the realtime kernel.

```bash
bash PKGBUILD.lazy.sh

# lazy
sudo pacman -U linux-cachyos-gcc-lazy-{6,h}*.zst

# lazy-rt
sudo pacman -U linux-cachyos-gcc-lazy-rt*.zst
```

Removal is via pacman as well, when no longer needed.

```text
# lazy
sudo pacman -Rsn \
  linux-cachyos-gcc-lazy \
  linux-cachyos-gcc-lazy-headers

# lazy-rt
sudo pacman -Rsn \
  linux-cachyos-gcc-lazy-rt \
  linux-cachyos-gcc-lazy-rt-headers
```

Optionally, select desired preemption via kernel argument.
For most cases "full" is what you want for low-latency.

```bash
# lazy
preempt=full (default)
preempt=lazy
preempt=laziest
preempt=none

# lazy-rt
preempt=full (default)
preempt=lazy
preempt=laziest
```

## Developer Notes

1. The `PKGBUILD.cachyos` is not used and left it here for comparison.
   I modified the file and saved to `PKGBUILD.lazy`. The `*.lazy.sh`
   script creates `PKGBUILD`.

2. This project pulls patch files from the CachyOS and ClearMod GitHub
   repositories. This may fail in the future when patches no longer align
   or due to kernel updates. Maybe, I'd include the patches here.

3. Failed to commit transaction (conflicting files). Initally, the package
   did not own the `/etc/mkinitcpio.d/linux-cachyos-gcc-lazy*.preset` file.
   Remove the file manually and try again.

