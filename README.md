# sdm845-live-fedora

A proof of concept that uses [mkosi][] to generate a compact UKI that can
be directly booted from the vendor bootloader of OnePlus6(T).

## Usage

NOTE: this is a very rough sketch until I've stabilized things further.

Build the UKI:

```sh
mkosi
# the built UKI is located at mkosi.output/image.efi
```

Build [my U-Boot tree][] and boot it:

```sh
cd /path/to/u-boot
make qcom_defconfig qcom-phone.config fastboot-wait.config
make -j$(nproc)
fastboot boot --kernel-offset '0x00008000' --page-size '4096' \
    --header-version=2 \
    --dtb dts/upstream/src/arm64/qcom/sdm845-oneplus-fajita.dtb \
    u-boot-nodtb.bin
```

Once U-Boot starts it will be waiting for fastboot commands.

Boot the UKI:

```sh
fastboot stage /path/to/mkosi.output/image.efi
fastboot oem run:'bootefi ${fastboot_addr_r}:${filesize}'
```

[rootfs-smoo profile](mkosi.profiles/rootfs-smoo/) builds the initrd with the locally checked out
[smoo](smoo/) gadget. The device starts `smoo-gadget` in the initrd and will mount `/sysroot` from
`/dev/disk/by-partlabel/rootfs`, so hand `smoo-host-cli --file` a GPT image whose root partition is
labelled `rootfs` (e.g. `sgdisk -n1:0:+2G -t1:8300 -c1:rootfs rootfs.img`).
When building with `mkosi -p rootfs-smoo` a ready-to-serve image is emitted at
`mkosi.output/rootfs-gpt.img`; it’s a GPT disk with a single `rootfs` partition formatted erofs.

[mkosi]: https://github.com/systemd/mkosi
[my U-Boot tree]: https://github.com/samcday/u-boot
