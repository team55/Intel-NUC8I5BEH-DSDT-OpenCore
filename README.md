## Based on Intel "NUC5"/"NUC6"/"NUC7"/"NUC8" DSDT patches by RehabMan

https://www.tonymacx86.com/threads/guide-intel-nuc7-nuc8-using-clover-uefi-nuc7i7bxx-nuc8i7bxx-etc.261711/

изначально инсталляция идет с конфигом
config_install_nuc7.plist и IntelMausiEthernet.kext (что бы сеть завести)

ссылаются на статью https://www.tonymacx86.com/threads/guide-booting-the-os-x-installer-on-laptops-with-clover.148093/

при необходимости добавляются Lilu.kext and IntelGraphicsFixup (HD615/HD620/HD630)


потом на машине запускаются скрипты настройки загрузчика (postinstall)


ighlights:
- KabyLake-R Core i7-8650U
- Intel UHD 620 graphics
- replaceable WiFi via M.2 2230 slot
- M.2 2280 for SSD
- dual-HDMI at back panel (one marked "Protected UHD")
- 4x USB3 ports (2x back, 2x front)
- Ethernet (works with IntelMausiEthernet.kext)
- no analog audio (audio works via HDMI audio)
- no Thunderbolt, no USB type C


- add EmuVariableUefi-64.efi to drivers64UEFI
(you will experience lockups on restart, shutdown, sleep, and SysPrefs->Startup Disk without it)
- use the nuc8 variant plists (config_install_nuc8_bc.plist, config_nuc8_bc.plist)
- use the nuc8 make install script ('make install_nuc8bc')
- in BIOS settings you *must* enable legacy boot (continue to boot UEFI, but enable legacy for CSM)
(you will have KP/reboot without it)



To start, choose "Load Defaults" (choose from the menu or press F9 in the BIOS setup).

Then change:
- Boot->Boot Configuration, disable "Network Boot"
- Power->Secondary Power Settings, "Wake on LAN from S4/S5", set to "Stay Off"

These settings are important but are already set as needed by "Load Defaults"
- Devices->Video, "IGD Minimum Memory" set to 64mb or 128mb
- Devices->Video, "IGD Aperture Size" set to 256mb
- Boot->Secure Boot, "Secure Boot" is disabled
- Security->Security Features, "Execute Disable Bit" is enabled.

Suggested:
- Boot->Boot Priority->Legacy Boot Priority, disable "Legacy Boot" (it will reduce confusion).
Exception: NUC8 (read above NUC8 notes)



### patches
To start, the developer tools must be installed. Run Terminal, and type:

xcode-select --install

Now it is time to install some more tools and all the kexts that are required...

!!!!!!!!!!!!!!!!
### todo - split to 2 separate steps (пишет на системный диск дрова)
!!!!!!!!!!!!!!!!

sh ./download.sh

### DO NOT RUN on primary system - only on target
sh ./install_downloads.sh

The download.sh script will automatically gather the latest version of all tools (patchmatic, iasl, MaciASL) and all the required kexts from bitbucket. The install_downloads.sh will automatically install them to the proper locations.

To finish the setup, we need a correctly patched ACPI.

In Terminal:

make
make install_nuc7

### Power Management

Everything required for CPU/IGPU power management is already installed with the steps above.
There is no longer any need to use the ssdtPRgen.sh script.

Be aware that hibernation (suspend to disk or S4 sleep) is not well supported on hackintosh.

You should disable it:
Code:
sudo pmset -a hibernatemode 0
sudo rm /var/vm/sleepimage
sudo mkdir /var/vm/sleepimage
Always check your hibernatemode after updates and disable it. System updates tend to re-enable it, although the trick above (making sleepimage a directory) tends to help.










This set of patches/makefile can be used to patch your Intel NUC5/NUC6/NUC7 ACPI.

The current repository actually uses only on-the-fly patches via config.plist and an additional SSDTs, SSDT-XOSI.aml, etc.  The files here should work for all the Broadwell NUC, Skylake NUC, Kaby Lake, and Coffee Lake NUC.

Please refer to this guide thread on tonymacx86.com for a step-by-step process, feedback, and questions:

Broadwell NUC5: http://tonymacx86.com/threads/guide-intel-broadwell-nuc5-using-clover-uefi-nuc5i5mhye-nuc5i3myhe-etc.191011/

Skylake NUC6: http://www.tonymacx86.com/threads/guide-intel-skylake-nuc6-using-clover-uefi-nuc6i5syk-etc.194177/

Kaby Lake NUC7: http://www.tonymacx86.com/threads/guide-intel-kaby-lake-nuc7-using-clover-uefi-nuc7i7bnh-nuc7i5bnk-nuc7i3bnh-etc.221123/

Coffee Lake NUC8: //REVIEW: URL TBD


### Change Log:

2018-10-14

- Add preliminary NUC8 "Bean Canyon" support


2018-10-10

- Completed many changes for WhateverGreen, AppleALC, and Mojave


2017-08-31

- Allow Skylake spoofing to work with NUC7 (4k@60 reported not working with native KBL graphics kexts, and Skylake spoof needed for 10.11.x)


2017-08-19

- Use Kaby Lake native support in 10.12.6


2017-05-26

- add Intel Compute Stick support (testing specifically on STCK2mv64CC)


2017-05-04

- add Kaby Lake NUC7 support

- switch to XCPM only CPU PM (just SSDT-PluginType1 content instead of full ssdtPRgen.sh SSDT)

- consolidate separate SSDTs into single model specific SSDT (SSDT-NUC*.aml) file


2016-06-18

- fixes some issues with ALC283 (lost/poor quality audio after period of LineIn idle, same after sleep/wake)


2016-06-12

- add preliminary NUC6 (Skylake) Skull Canyon support


2016-05-30

- add NUC6 (Skylake) support


2016-04-16

- create based on Gigabyte BRIX project
