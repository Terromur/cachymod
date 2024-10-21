# CachyMod

Run a 6.11 kernel with lazy preemption capability on [CachyOS](https://cachyos.org/).

If running NVIDIA graphics, first switch to DKMS for future proof CachyOS
updating the NVIDIA stack to a later release.

```bash
# Obtain a list of NVIDIA kernel modules.
pacman -Q | awk '/^linux-cachyos-.*nvidia/ { print $1 }'

# Remove any prebuilt NVIDIA kernel modules.
sudo pacman -Rsn linux-cachyos-nvidia

# Install NVIDIA sources for DKMS (choose one).
sudo pacman -S nvidia-dkms
sudo pacman -S nvidia-open-dkms
```

## Building and Installation

Copy the `linux-cachyos-lazy` folder to a work area with ample storage space,
and change directory. Adjust build options in `PKGBUILD.{lazy,nobpf}.sh`.

The `nobpf` variant is `lazy` with the BPF filter and debugging disabled.
Note: The `ananicy-cpp` service will not work with this kernel. Stop and
disable the service before running this flavor.

```bash
bash PKGBUILD.lazy.sh
sudo pacman -U linux-cachyos-gcc-lazy*.zst

bash PKGBUILD.nobpf.sh
sudo pacman -U linux-cachyos-gcc-nobpf*.zst
```

Removal is via pacman as well, when no longer needed.

```text
sudo pacman -Rsn \
  linux-cachyos-gcc-lazy \
  linux-cachyos-gcc-lazy-headers

sudo pacman -Rsn \
  linux-cachyos-gcc-nobpf \
  linux-cachyos-gcc-nobpf-headers
```

Select desired preemption via kernel argument.

```bash
preempt=none
preempt=laziest
preempt=lazy (default)
preempt=full
```

## Developer Notes

1. The `PKGBUILD.cachyos` is not used and left here for comparison.
   I modified the file and saved to `PKGBUILD.lazy`. The `*.lazy.sh`
   script creates `PKGBUILD`.

2. The `config.sh` script is where I tried various Clear Linux defaults.
   Some of the configuration matches CachyOS defaults. I did not prune
   matching entries.

3. This project pulls patch files from the CachyOS and ClearMod GitHub
   repositories. This may fail in the future when patches no longer align
   or due to kernel updates. Maybe, I'd include the patches here.

4. `800Hz/2.5ms` and `600Hz/1.6(6)ms` work best on my machine.

