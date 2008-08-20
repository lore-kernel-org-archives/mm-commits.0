From: akpm@linux-foundation.org
Subject: - linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 20 Aug 2008 13:02:28 -0700
Message-ID: <200808202002.m7KK2SDe029001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755066AbYHTUCa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 16:02:30 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m7KK2S9C027475
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 20 Aug 2008 13:02:29 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/pci/aec62xx.c      |    3 ---
 drivers/ide/pci/cy82c693.c     |    3 ---
 drivers/ide/pci/hpt366.c       |    3 ---
 drivers/ide/pci/it821x.c       |    3 ---
 drivers/ide/pci/pdc202xx_new.c |    3 ---
 drivers/ide/pci/siimage.c      |    3 ---
 drivers/ide/pci/sis5513.c      |    3 ---
 drivers/ide/pci/via82cxxx.c    |    3 ---
 include/linux/ata.h            |   15 ---------------
 9 files changed, 39 deletions(-)

diff -puN drivers/ide/pci/aec62xx.c~linux-next-git-rejects drivers/ide/pci/aec62xx.c
--- a/drivers/ide/pci/aec62xx.c~linux-next-git-rejects
+++ a/drivers/ide/pci/aec62xx.c
@@ -307,13 +307,10 @@ static struct pci_driver driver = {
 	.id_table	= aec62xx_pci_tbl,
 	.probe		= aec62xx_init_one,
 	.remove		= __devexit_p(aec62xx_remove),
-<<<<<<< HEAD:drivers/ide/pci/aec62xx.c
-=======
 #ifdef CONFIG_PM
 	.suspend	= ide_pci_suspend,
 	.resume		= ide_pci_resume,
 #endif
->>>>>>> FETCH_HEAD:drivers/ide/pci/aec62xx.c
 };
 
 static int __init aec62xx_ide_init(void)
diff -puN drivers/ide/pci/cy82c693.c~linux-next-git-rejects drivers/ide/pci/cy82c693.c
--- a/drivers/ide/pci/cy82c693.c~linux-next-git-rejects
+++ a/drivers/ide/pci/cy82c693.c
@@ -336,13 +336,10 @@ static struct pci_driver driver = {
 	.id_table	= cy82c693_pci_tbl,
 	.probe		= cy82c693_init_one,
 	.remove		= __devexit_p(cy82c693_remove),
-<<<<<<< HEAD:drivers/ide/pci/cy82c693.c
-=======
 #ifdef CONFIG_PM
 	.suspend	= ide_pci_suspend,
 	.resume		= ide_pci_resume,
 #endif
->>>>>>> FETCH_HEAD:drivers/ide/pci/cy82c693.c
 };
 
 static int __init cy82c693_ide_init(void)
diff -puN drivers/ide/pci/hpt366.c~linux-next-git-rejects drivers/ide/pci/hpt366.c
--- a/drivers/ide/pci/hpt366.c~linux-next-git-rejects
+++ a/drivers/ide/pci/hpt366.c
@@ -1625,13 +1625,10 @@ static struct pci_driver driver = {
 	.id_table	= hpt366_pci_tbl,
 	.probe		= hpt366_init_one,
 	.remove		= __devexit_p(hpt366_remove),
-<<<<<<< HEAD:drivers/ide/pci/hpt366.c
-=======
 #ifdef CONFIG_PM
 	.suspend	= ide_pci_suspend,
 	.resume		= ide_pci_resume,
 #endif
->>>>>>> FETCH_HEAD:drivers/ide/pci/hpt366.c
 };
 
 static int __init hpt366_ide_init(void)
diff -puN drivers/ide/pci/it821x.c~linux-next-git-rejects drivers/ide/pci/it821x.c
--- a/drivers/ide/pci/it821x.c~linux-next-git-rejects
+++ a/drivers/ide/pci/it821x.c
@@ -681,13 +681,10 @@ static struct pci_driver driver = {
 	.id_table	= it821x_pci_tbl,
 	.probe		= it821x_init_one,
 	.remove		= __devexit_p(it821x_remove),
-<<<<<<< HEAD:drivers/ide/pci/it821x.c
-=======
 #ifdef CONFIG_PM
 	.suspend	= ide_pci_suspend,
 	.resume		= ide_pci_resume,
 #endif
->>>>>>> FETCH_HEAD:drivers/ide/pci/it821x.c
 };
 
 static int __init it821x_ide_init(void)
diff -puN drivers/ide/pci/pdc202xx_new.c~linux-next-git-rejects drivers/ide/pci/pdc202xx_new.c
--- a/drivers/ide/pci/pdc202xx_new.c~linux-next-git-rejects
+++ a/drivers/ide/pci/pdc202xx_new.c
@@ -566,13 +566,10 @@ static struct pci_driver driver = {
 	.id_table	= pdc202new_pci_tbl,
 	.probe		= pdc202new_init_one,
 	.remove		= __devexit_p(pdc202new_remove),
-<<<<<<< HEAD:drivers/ide/pci/pdc202xx_new.c
-=======
 #ifdef CONFIG_PM
 	.suspend	= ide_pci_suspend,
 	.resume		= ide_pci_resume,
 #endif
->>>>>>> FETCH_HEAD:drivers/ide/pci/pdc202xx_new.c
 };
 
 static int __init pdc202new_ide_init(void)
diff -puN drivers/ide/pci/siimage.c~linux-next-git-rejects drivers/ide/pci/siimage.c
--- a/drivers/ide/pci/siimage.c~linux-next-git-rejects
+++ a/drivers/ide/pci/siimage.c
@@ -835,13 +835,10 @@ static struct pci_driver driver = {
 	.id_table	= siimage_pci_tbl,
 	.probe		= siimage_init_one,
 	.remove		= __devexit_p(siimage_remove),
-<<<<<<< HEAD:drivers/ide/pci/siimage.c
-=======
 #ifdef CONFIG_PM
 	.suspend	= ide_pci_suspend,
 	.resume		= ide_pci_resume,
 #endif
->>>>>>> FETCH_HEAD:drivers/ide/pci/siimage.c
 };
 
 static int __init siimage_ide_init(void)
diff -puN drivers/ide/pci/sis5513.c~linux-next-git-rejects drivers/ide/pci/sis5513.c
--- a/drivers/ide/pci/sis5513.c~linux-next-git-rejects
+++ a/drivers/ide/pci/sis5513.c
@@ -610,13 +610,10 @@ static struct pci_driver driver = {
 	.id_table	= sis5513_pci_tbl,
 	.probe		= sis5513_init_one,
 	.remove		= __devexit_p(sis5513_remove),
-<<<<<<< HEAD:drivers/ide/pci/sis5513.c
-=======
 #ifdef CONFIG_PM
 	.suspend	= ide_pci_suspend,
 	.resume		= ide_pci_resume,
 #endif
->>>>>>> FETCH_HEAD:drivers/ide/pci/sis5513.c
 };
 
 static int __init sis5513_ide_init(void)
diff -puN drivers/ide/pci/via82cxxx.c~linux-next-git-rejects drivers/ide/pci/via82cxxx.c
--- a/drivers/ide/pci/via82cxxx.c~linux-next-git-rejects
+++ a/drivers/ide/pci/via82cxxx.c
@@ -492,13 +492,10 @@ static struct pci_driver driver = {
 	.id_table 	= via_pci_tbl,
 	.probe 		= via_init_one,
 	.remove		= __devexit_p(via_remove),
-<<<<<<< HEAD:drivers/ide/pci/via82cxxx.c
-=======
 #ifdef CONFIG_PM
 	.suspend	= ide_pci_suspend,
 	.resume		= ide_pci_resume,
 #endif
->>>>>>> FETCH_HEAD:drivers/ide/pci/via82cxxx.c
 };
 
 static int __init via_ide_init(void)
diff -puN include/linux/ata.h~linux-next-git-rejects include/linux/ata.h
--- a/include/linux/ata.h~linux-next-git-rejects
+++ a/include/linux/ata.h
@@ -554,10 +554,6 @@ static inline int ata_id_has_fua(const u
 static inline int ata_id_has_flush(const u16 *id)
 {
 	if ((id[ATA_ID_COMMAND_SET_2] & 0xC000) != 0x4000)
-<<<<<<< HEAD:include/linux/ata.h
-		return 0;
-	return id[ATA_ID_COMMAND_SET_2] & (1 << 12);
-=======
 		return 0;
 	return id[ATA_ID_COMMAND_SET_2] & (1 << 12);
 }
@@ -569,7 +565,6 @@ static inline int ata_id_flush_enabled(c
 	if ((id[ATA_ID_CSF_DEFAULT] & 0xC000) != 0x4000)
 		return 0;
 	return id[ATA_ID_CFS_ENABLE_2] & (1 << 12);
->>>>>>> FETCH_HEAD:include/linux/ata.h
 }
 
 static inline int ata_id_has_flush_ext(const u16 *id)
@@ -577,8 +572,6 @@ static inline int ata_id_has_flush_ext(c
 	if ((id[ATA_ID_COMMAND_SET_2] & 0xC000) != 0x4000)
 		return 0;
 	return id[ATA_ID_COMMAND_SET_2] & (1 << 13);
-<<<<<<< HEAD:include/linux/ata.h
-=======
 }
 
 static inline int ata_id_flush_ext_enabled(const u16 *id)
@@ -592,7 +585,6 @@ static inline int ata_id_flush_ext_enabl
 	 * so check bit 10 too
 	 */
 	return (id[ATA_ID_CFS_ENABLE_2] & 0x2400) == 0x2400;
->>>>>>> FETCH_HEAD:include/linux/ata.h
 }
 
 static inline int ata_id_has_lba48(const u16 *id)
@@ -602,8 +594,6 @@ static inline int ata_id_has_lba48(const
 	if (!ata_id_u64(id, ATA_ID_LBA_CAPACITY_2))
 		return 0;
 	return id[ATA_ID_COMMAND_SET_2] & (1 << 10);
-<<<<<<< HEAD:include/linux/ata.h
-=======
 }
 
 static inline int ata_id_lba48_enabled(const u16 *id)
@@ -613,7 +603,6 @@ static inline int ata_id_lba48_enabled(c
 	if ((id[ATA_ID_CSF_DEFAULT] & 0xC000) != 0x4000)
 		return 0;
 	return id[ATA_ID_CFS_ENABLE_2] & (1 << 10);
->>>>>>> FETCH_HEAD:include/linux/ata.h
 }
 
 static inline int ata_id_hpa_enabled(const u16 *id)
@@ -687,9 +676,6 @@ static inline unsigned int ata_id_major_
 
 static inline int ata_id_is_sata(const u16 *id)
 {
-<<<<<<< HEAD:include/linux/ata.h
-	return ata_id_major_version(id) >= 5 && id[ATA_ID_HW_CONFIG] == 0;
-=======
 	/*
 	 * See if word 93 is 0 AND drive is at least ATA-5 compatible
 	 * verifying that word 80 by casting it to a signed type --
@@ -699,7 +685,6 @@ static inline int ata_id_is_sata(const u
 	if (id[ATA_ID_HW_CONFIG] == 0 && (short)id[ATA_ID_MAJOR_VER] >= 0x0020)
 		return 1;
 	return 0;
->>>>>>> FETCH_HEAD:include/linux/ata.h
 }
 
 static inline int ata_id_has_tpm(const u16 *id)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
proc-self-maps-doesnt-display-the-real-file-offset-checkpatch-fixes.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
arch-x86-kernel-io_apic_32c-fix-printk-warnings.patch
git-alsa-tiwai.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
git-drm.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
kvm-is-still-busted-on-ia64.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
git-jg-misc.patch
git-kvm.patch
drivers-ata-pata_it821xc-fix-warning.patch
git-mtd.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-checkpatch-fixes.patch
power-support-for-texas-instruments-bq27x00-battery-managers-checkpatch-fixes.patch
power-support-for-texas-instruments-bq27x00-battery-managers-tweaks.patch
ftrace-printk-formatting-infrastructure.patch
scsi-gdthc-use-unaligned-access-helpers.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
git-watchdog.patch
git-xtensa.patch
drivers-char-ipmi-ipmi_si_intfc-default_find_bmc-fix-leak.patch
mm-dirty-page-tracking-race-fix-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
h8300-generic_bug-support-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
nilfs2-continuous-snapshotting-file-system-fix.patch
nilfs2-continuous-snapshotting-file-system-fix-fix-2.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

