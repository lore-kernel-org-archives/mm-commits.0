From: akpm@linux-foundation.org
Subject: - git-dvb-fixup.patch removed from -mm tree
Date: Mon, 06 Aug 2007 00:34:52 -0700
Message-ID: <200708060734.l767YqTe015641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47281 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756166AbXHFHfA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 03:35:00 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l767YvEC000930
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 6 Aug 2007 00:34:58 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-dvb-fixup
has been removed from the -mm tree.  Its filename was
     git-dvb-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-dvb-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/ivtv/ivtv-driver.h |    4 --
 drivers/media/video/zoran_driver.c     |   37 -----------------------
 include/linux/i2c-id.h                 |    1 
 3 files changed, 1 insertion(+), 41 deletions(-)

diff -puN drivers/media/video/zoran_driver.c~git-dvb-fixup drivers/media/video/zoran_driver.c
--- a/drivers/media/video/zoran_driver.c~git-dvb-fixup
+++ a/drivers/media/video/zoran_driver.c
@@ -127,7 +127,6 @@ const struct zoran_format zoran_formats[
 		.depth = 15,
 		.flags = ZORAN_FORMAT_CAPTURE |
 			 ZORAN_FORMAT_OVERLAY,
-<<<<<<< HEAD/drivers/media/video/zoran_driver.c
 		.vfespfr = ZR36057_VFESPFR_RGB555|ZR36057_VFESPFR_ErrDif,
 	}, {
 		.name = "16-bit RGB LE",
@@ -138,28 +137,10 @@ const struct zoran_format zoran_formats[
 			 ZORAN_FORMAT_OVERLAY,
 		.vfespfr = ZR36057_VFESPFR_RGB565|ZR36057_VFESPFR_ErrDif|
 			   ZR36057_VFESPFR_LittleEndian,
-=======
-		.vfespfr = ZR36057_VFESPFR_RGB555|ZR36057_VFESPFR_ErrDif,
->>>>>>> /drivers/media/video/zoran_driver.c
-	}, {
-<<<<<<< HEAD/drivers/media/video/zoran_driver.c
-		.name = "16-bit RGB BE",
-		ZFMT(-1,
-		     V4L2_PIX_FMT_RGB565, V4L2_COLORSPACE_SRGB),
-=======
-		.name = "16-bit RGB LE",
-		ZFMT(VIDEO_PALETTE_RGB565,
-		     V4L2_PIX_FMT_RGB565, V4L2_COLORSPACE_SRGB),
-		.depth = 16,
-		.flags = ZORAN_FORMAT_CAPTURE |
-			 ZORAN_FORMAT_OVERLAY,
-		.vfespfr = ZR36057_VFESPFR_RGB565|ZR36057_VFESPFR_ErrDif|
-			   ZR36057_VFESPFR_LittleEndian,
 	}, {
 		.name = "16-bit RGB BE",
 		ZFMT(-1,
 		     V4L2_PIX_FMT_RGB565, V4L2_COLORSPACE_SRGB),
->>>>>>> /drivers/media/video/zoran_driver.c
 		.depth = 16,
 		.flags = ZORAN_FORMAT_CAPTURE |
 			 ZORAN_FORMAT_OVERLAY,
@@ -171,21 +152,8 @@ const struct zoran_format zoran_formats[
 		.depth = 24,
 		.flags = ZORAN_FORMAT_CAPTURE |
 			 ZORAN_FORMAT_OVERLAY,
-<<<<<<< HEAD/drivers/media/video/zoran_driver.c
 		.vfespfr = ZR36057_VFESPFR_RGB888|ZR36057_VFESPFR_Pack24,
-=======
-		.vfespfr = ZR36057_VFESPFR_RGB888|ZR36057_VFESPFR_Pack24,
-	}, {
-		.name = "32-bit RGB LE",
-		ZFMT(VIDEO_PALETTE_RGB32,
-		     V4L2_PIX_FMT_BGR32, V4L2_COLORSPACE_SRGB),
-		.depth = 32,
-		.flags = ZORAN_FORMAT_CAPTURE |
-			 ZORAN_FORMAT_OVERLAY,
-		.vfespfr = ZR36057_VFESPFR_RGB888|ZR36057_VFESPFR_LittleEndian,
->>>>>>> /drivers/media/video/zoran_driver.c
 	}, {
-<<<<<<< HEAD/drivers/media/video/zoran_driver.c
 		.name = "32-bit RGB LE",
 		ZFMT(VIDEO_PALETTE_RGB32,
 		     V4L2_PIX_FMT_BGR32, V4L2_COLORSPACE_SRGB),
@@ -197,11 +165,6 @@ const struct zoran_format zoran_formats[
 		.name = "32-bit RGB BE",
 		ZFMT(-1,
 		     V4L2_PIX_FMT_RGB32, V4L2_COLORSPACE_SRGB),
-=======
-		.name = "32-bit RGB BE",
-		ZFMT(-1,
-		     V4L2_PIX_FMT_RGB32, V4L2_COLORSPACE_SRGB),
->>>>>>> /drivers/media/video/zoran_driver.c
 		.depth = 32,
 		.flags = ZORAN_FORMAT_CAPTURE |
 			 ZORAN_FORMAT_OVERLAY,
diff -puN drivers/media/video/ivtv/ivtv-driver.h~git-dvb-fixup drivers/media/video/ivtv/ivtv-driver.h
--- a/drivers/media/video/ivtv/ivtv-driver.h~git-dvb-fixup
+++ a/drivers/media/video/ivtv/ivtv-driver.h
@@ -397,13 +397,9 @@ struct ivtv_mailbox_data {
 #define IVTV_F_I_WORK_HANDLER_YUV  17	/* there is work to be done for YUV */
 #define IVTV_F_I_WORK_HANDLER_PIO  18	/* there is work to be done for PIO */
 #define IVTV_F_I_PIO		   19	/* PIO in progress */
-<<<<<<< HEAD/drivers/media/video/ivtv/ivtv-driver.h
-#define IVTV_F_I_DEC_PAUSED	   20 	/* the decoder is paused */
-=======
 #define IVTV_F_I_DEC_PAUSED	   20 	/* the decoder is paused */
 #define IVTV_F_I_INITED		   21 	/* set after first open */
 #define IVTV_F_I_FAILED		   22 	/* set if first open failed */
->>>>>>> /drivers/media/video/ivtv/ivtv-driver.h
 
 /* Event notifications */
 #define IVTV_F_I_EV_DEC_STOPPED	   28	/* decoder stopped event */
diff -puN include/linux/i2c-id.h~git-dvb-fixup include/linux/i2c-id.h
--- a/include/linux/i2c-id.h~git-dvb-fixup
+++ a/include/linux/i2c-id.h
@@ -120,6 +120,7 @@
 #define I2C_DRIVERID_WM8753	91	/* Wolfson WM8753 audio codec */
 #define I2C_DRIVERID_LM4857 	92 	/* LM4857 Audio Amplifier */
 #define I2C_DRIVERID_CS4270	93	/* Cirrus Logic 4270 audio codec */
+#define I2C_DRIVERID_VP27SMPX	94	/* Panasonic VP27s tuner internal MPX */
 
 #define I2C_DRIVERID_I2CDEV	900
 #define I2C_DRIVERID_ARP        902    /* SMBus ARP Client              */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

genirq-temporary-fix-for-level-triggered-irq-resend-fix.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
dma-arch-fix.patch
git-dvb-fixup.patch
adbhid-produce-all-capslock-key-events-fix.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
iforce-warning-fix.patch
git-kvm.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
fix-ide-ide-add-ide-set-pio-take3.patch
fix-ide-ide-add-platform-ide-driver.patch
git-mtd.patch
git-mtd-fix-printk-warning-in-jffs2_block_check_erase.patch
mtdoops-printk-warning-fixes.patch
ax88796-printk-fixes.patch
natsemi-fix-netdev-error-acounting.patch
git-ixgbe-build-fix.patch
ip_auto_config-fix-fix.patch
fib_trie-cleanup-fix.patch
introduce-u16_max-and-u32_max-fix.patch
introduce-strtol_check_range-fix.patch
git-ocfs2.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
aacraid-rename-check_reset.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-unionfs-build-fix.patch
git-unionfs-fix-2.patch
mct_u232-convert-to-proper-speed-handling-api-fix.patch
git-wireless.patch
merge-the-sonics-silicon-backplane-subsystem-fix.patch
ssb-chipcommon-add-function-to-get-processor-clock-fix.patch
ssb-mainc-needs-dma-mappingh.patch
revert-x86_64-mm-pci-mmconfig-eax.patch
fix-x86_64-mm-early-quirks-unification.patch
x86_64-clean-up-apicid_to_node-declaration.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-newsetup-fixup.patch
git-xfs.patch
git-kgdb-fixup.patch
git-kgdb-arm-fix.patch
git-kgdb-mips-fix.patch
git-kgdb-vs-optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch
git-kgdb-vs-optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft-2.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static-fix.patch
acpi_battery_add-use-after-free.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
deprecate-aout-elf-interpreters-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ecryptfs-printk-warning-fixes.patch
tdfxfb-mtrr-support-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
w1-build-fix.patch
