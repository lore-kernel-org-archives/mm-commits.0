From: akpm@linux-foundation.org
Subject: - git-wireless-fixup.patch removed from -mm tree
Date: Fri, 26 Oct 2007 11:37:11 -0700
Message-ID: <200710261837.l9QIbBf0008688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44682 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756846AbXJZShS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Oct 2007 14:37:18 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l9QIbBdk027376
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 26 Oct 2007 11:37:17 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-wireless-fixup
has been removed from the -mm tree.  Its filename was
     git-wireless-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-wireless-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/Kconfig  |   24 ------------------------
 drivers/net/wireless/Makefile |    3 ---
 2 files changed, 27 deletions(-)

diff -puN drivers/net/wireless/Kconfig~git-wireless-fixup drivers/net/wireless/Kconfig
--- a/drivers/net/wireless/Kconfig~git-wireless-fixup
+++ a/drivers/net/wireless/Kconfig
@@ -387,8 +387,6 @@ config PCI_HERMES
 	  common.  Some of the built-in wireless adaptors in laptops are of
 	  this variety.
 
-<<<<<<< HEAD:drivers/net/wireless/Kconfig
-=======
 config ATMEL
       tristate "Atmel at76c50x chipset  802.11b support"
       depends on (PCI || PCMCIA) && WLAN_80211
@@ -421,7 +419,6 @@ config USB_ATMEL
 	  Enable support for USB Wireless devices using Atmel at76c503,
 	  at76c505 or at76c505a chips.
 
->>>>>>> FETCH_HEAD:drivers/net/wireless/Kconfig
 config PCMCIA_HERMES
 	tristate "Hermes PCMCIA card support"
 	depends on PCMCIA && HERMES
@@ -591,28 +588,20 @@ config RTL8187
 
 	  Thanks to Realtek for their support!
 
-<<<<<<< HEAD:drivers/net/wireless/Kconfig
 config ADM8211
 	tristate "ADMtek ADM8211 support"
 	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
 	select CRC32
 	select EEPROM_93CX6
-=======
 config ATH5K
 	tristate "Atheros 5xxx wireless cards support"
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
 	default m
->>>>>>> FETCH_HEAD:drivers/net/wireless/Kconfig
 	---help---
-<<<<<<< HEAD:drivers/net/wireless/Kconfig
 	  This driver is for ADM8211A, ADM8211B, and ADM8211C based cards.
 	  These are PCI/mini-PCI/Cardbus 802.11b chips found in cards such as:
-=======
 	  This module adds support for atheros 5xxx (e.g. 5212) wireless
 	  cards. If you have this card in your PC, select this to be build.
->>>>>>> FETCH_HEAD:drivers/net/wireless/Kconfig
-
-<<<<<<< HEAD:drivers/net/wireless/Kconfig
 	  Xterasys Cardbus XN-2411b
 	  Blitz NetWave Point PC
 	  TrendNet 221pc
@@ -624,20 +613,12 @@ config ATH5K
 	  Corega WLPCIB-11
 	  SMC 2602W V2 EU
 	  D-Link DWL-520 Revision C
-=======
 	  This driver uses the kernel's mac80211 subsystem.
->>>>>>> FETCH_HEAD:drivers/net/wireless/Kconfig
-
-<<<<<<< HEAD:drivers/net/wireless/Kconfig
 	  However, some of these cards have been replaced with other chips
 	  like the RTL8180L (Xterasys Cardbus XN-2411b, Belkin F5D6001) or
 	  the Ralink RT2400 (SMC2635W) without a model number change.
-=======
 	  If you choose to build a module, it'll be called ath5k. Say M if
 	  unsure.
->>>>>>> FETCH_HEAD:drivers/net/wireless/Kconfig
-
-<<<<<<< HEAD:drivers/net/wireless/Kconfig
 	  Thanks to Infineon-ADMtek for their support of this driver.
 
 config P54_COMMON
@@ -654,17 +635,12 @@ config P54_PCI
 	depends on P54_COMMON && PCI
 
 source "drivers/net/wireless/iwlwifi/Kconfig"
-=======
->>>>>>> FETCH_HEAD:drivers/net/wireless/Kconfig
 source "drivers/net/wireless/hostap/Kconfig"
 source "drivers/net/wireless/bcm43xx/Kconfig"
 source "drivers/net/wireless/b43/Kconfig"
 source "drivers/net/wireless/b43legacy/Kconfig"
 source "drivers/net/wireless/zd1211rw/Kconfig"
-<<<<<<< HEAD:drivers/net/wireless/Kconfig
 source "drivers/net/wireless/rt2x00/Kconfig"
-=======
 source "drivers/net/wireless/zd1211rw-mac80211/Kconfig"
->>>>>>> FETCH_HEAD:drivers/net/wireless/Kconfig
 
 endmenu
diff -puN drivers/net/wireless/Makefile~git-wireless-fixup drivers/net/wireless/Makefile
--- a/drivers/net/wireless/Makefile~git-wireless-fixup
+++ a/drivers/net/wireless/Makefile
@@ -53,7 +53,6 @@ obj-$(CONFIG_LIBERTAS)		+= libertas/
 rtl8187-objs		:= rtl8187_dev.o rtl8187_rtl8225.o
 obj-$(CONFIG_RTL8187)	+= rtl8187.o
 
-<<<<<<< HEAD:drivers/net/wireless/Makefile
 obj-$(CONFIG_ADM8211)	+= adm8211.o
 
 obj-$(CONFIG_IWLWIFI)	+= iwlwifi/
@@ -62,6 +61,4 @@ obj-$(CONFIG_RT2X00)	+= rt2x00/
 obj-$(CONFIG_P54_COMMON)	+= p54common.o
 obj-$(CONFIG_P54_USB)		+= p54usb.o
 obj-$(CONFIG_P54_PCI)		+= p54pci.o
-=======
 obj-$(CONFIG_ATH5K)	+= ath5k/
->>>>>>> FETCH_HEAD:drivers/net/wireless/Makefile
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sunrpc-fix-rpc-debugging-checkpatch-fixes.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
revert-gregkh-driver-block-device.patch
git-hwmon.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
fix-appletouch-geyser-1-breakage-checkpatch-fixes.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
libata-pata_it821x-improve-handling-of-poorly-compatible-emulations-checkpatch-fixes.patch
ide-arm-hack.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
nf_ct_alloc_hashtable-use-__gfp_nowarn.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
fix-build-breakage-if-sysfs-fix.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
git-unionfs.patch
git-watchdog.patch
watchdog-add-nano-7240-driver-checkpatch-fixes.patch
git-wireless.patch
git-wireless-fixup.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
git-x86.patch
git-x86-fixup.patch
oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes.patch
x86-fix-config_smp-warning-in-processorc-fix.patch
i386-and-x86_64-randomize-brk-fix.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
pie-executable-randomization.patch
pie-executable-randomization-checkpatch-fixes.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
remove-warnings-for-longstanding-conditions-checkpatch-fixes.patch
sync_sb_inodes-propagate-errors.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
