# CachyMod

Run a 6.11 kernel with lazy preemption capability on [CachyOS](https://cachyos.org/).

Copy the `linux-cachyos-lazy` folder to a work area with ample storage space,
and change directory. Adjust variables in `PKGBUILD.lazy.sh` (default 600Hz).

If running NVIDIA graphics, first switch to DKMS for future proof CachyOS
updating the NVIDIA stack to a later release.

```bash
# Obtain a list of NVIDIA kernel modules.
pacman -Q | awk '/^linux-cachyos-.*nvidia/ { print $1 }'

# Remove the prebuilt NVIDIA kernel modules.
sudo pacman -Rsn linux-cachyos-nvidia
sudo pacman -Rsn linux-cachyos-gcc-lazy-nvidia

# Install NVIDIA sources for DKMS.
sudo pacman -S nvidia-dkms
```

Building the kernel and installation.

```bash
bash PKGBUILD.lazy.sh
sudo pacman -U --needed linux-cachyos-gcc-lazy*.zst
```

Removal is via pacman as well, when no longer needed.

```text
sudo pacman -Rsn \
  linux-cachyos-gcc-lazy \
  linux-cachyos-gcc-lazy-headers
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
   Some of the configuration match CachyOS defaults. I did not prune
   matching entries.

3. This project pulls patch files from the CachyOS and ClearMod GitHub
   repositories. This may fail in the future when patches no longer align
   or due to kernel updates. Maybe, I'd include the patches here.

4. `800Hz/2.5ms` and `600Hz/1.6(6)ms` work best on my machine.

