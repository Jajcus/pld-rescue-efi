
echo -on

if exists fs0:\pldrcd.nsh then
  fs0:
  set SYSCFG_PATH fs0:\EFI\BOOT
  cd \
  pldrcd.nsh
  goto End
endif
if exists fs1:\pldrcd.nsh then
  fs1:
  set SYSCFG_PATH fs1:\EFI\BOOT
  cd \
  pldrcd.nsh
  goto End
endif
if exists fs2:\pldrcd.nsh then
  fs2:
  set SYSCFG_PATH fs2:\EFI\BOOT
  cd \
  pldrcd.nsh
  goto End
endif
if exists fs3:\pldrcd.nsh then
  fs3:
  set SYSCFG_PATH fs3:\EFI\BOOT
  cd \
  pldrcd.nsh
  goto End
endif

echo pldrcd.nsh not found

:End

# vi: ft=text ff=dos
