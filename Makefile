
ADDONS=pld001.tar.bz2 pld002.tar.bz2 pld003.tar.bz2 pld004.tar.bz2 pld101.tar.bz2

hybrid.iso: efiboot.img new/custom/custom.cpi new/rescue6.cpi
	./make_hybrid_iso

efiboot.img: new/custom/custom.cpi new/rescue6.cpi /boot/vmlinuz-rescuecd \
		efiboot/EFI/BOOT/BOOTX64.EFI /lib/efi/x64/elilo.efi efiboot/*
	./make_efiboot_img

efiboot/EFI/BOOT/BOOTX64.EFI: /lib/efi/x64/Shell.efi
	mkdir -p efiboot/EFI/BOOT
	cp $< $@

efiboot/elilo.efi: /lib/efi/x64/elilo.efi
	cp $< $@

new/rescue6.cpi: orig/rescue6.cpi
	[ ! -e new ] || rm -rf new
	cp -a orig new

new/custom/custom.cpi: new/rescue6.cpi $(ADDONS)
	[ ! -e new/custom/files ] || rm -rf new/custom/files
	mkdir -p new/custom/files
	cp $(ADDONS) new/custom/files
	cd new/custom/files && \
	ls | cpio  -H newc -o > ../custom.cpi
	rm -rf new/custom/files

pld001.tar.bz2:
	rpm -ql libicu | tar cjf $@ -T-

pld002.tar.bz2:
	rpm -ql gdisk | tar cjf $@ -T-

pld003.tar.bz2:
	rpm -ql efibootmgr | tar cjf $@ -T-

pld004.tar.bz2:
	rpm -ql kernel-rescuecd | grep -vE '(^/boot|/source$$|/build$$)' | tar cjf $@ -T-

pld101.tar.bz2:
	cd run_ldconfig && tar cjf ../$@ *

clean:
	rm -fr *.iso *.img pld[01]*.tar.bz2 efiboot/EFI/BOOT/BOOTX64.EFI new
