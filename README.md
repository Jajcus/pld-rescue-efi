EFI 'port' of PLD Rescue CD
===========================

This is a set of hacks which allow to create a PLD Rescue CD (or USB stick)
bootable from EFI firmware (but with Secure Boot disabled).

The original RCD can be usually booted in the 'legacy' mode of a EFI-capable
hardware, but then EFI interface is not available to kernel, which makes it
hard to properly set up a system for EFI boot.

This project makes the RCD system EFI-bootable and adds two tools useful for
EFI setup: *gdisk* (for GPT partitioning) and *efibootmgr* (for setting up EFI
boot loaders)

Requirements
------------

To build the image you need:

* [The original PLD Rescue CD](http://rescuecd.pld-linux.org/) These scripts
  were made for the [Beta 2013-03-12](http://rescuecd.pld-linux.org/beta/) and
  probably won't work with anything else. Only the 64-bit versions are
  supported.
* Root shell on a x86_64 PLD system with the following packages installed:a
  + make
  + kernel-rescuecd >= 3.10.17-1
  + libicu
  + gdisk
  + efibootmgr
  + cpio
  + efi-shell-x64
  + elilo
  + dosfstools
  + syslinux
  + cdrkit-mkisofs (or other compatible 'mkisofs')

Building
--------

To build the Rescue image:

* Check out this code
* Make the 'orig' directory and mount the original PLD Rescue CD there or copy its contents there
* Issue 'make'

If everything goes well, then you will get two image files: *efiboot.img* and *hybrid.iso*

Usage
-----

*hybrid.iso* can be burn on a CD-R using `cdrecord` and can be booted on legacy BIOS and EFI systems

*efiboot.img* can be written do a USB stick (`cat efiboot.img > /dev/sdX`) and will be bootable from EFI systems only.

Secure boot is not currently supported, so it needs to be disabled in the BIOS before the system can be booted.

When booted in EFI mode it will enter EFI Shell. Enter the boot option ('aa' usually) in the shell and PLD will boot.

TODO
----

There is still to be improved:
* better bootloader/chooser. EFI shell is great because of the flexibility, but it looks bad and currently requires interaction. ELILO won't allow booting shell, GRUB2 is too complex… rEFInd maybe?
* Secure Boot support. Basic *shim* with custom key should do
* Integrate this upstream
* EFI-only ISO image

How this works
--------------

* a *custom.cpi* archive is created with the extra EFI tools
* a disk image with a FAT partition is created, as EFI can only boot from FAT
* the EFI shell is installed as the boot loaded on that FAT file system
* there are EFI shell scripts to find and start the Linux kernel there. The
  kernel contains EFI stub, so it is loaded as an EFI 'application'
* the *custom.cpi* archive is appended to the original RCD initrd image, as
  the kernel EFI stub can load only a single initrd file
