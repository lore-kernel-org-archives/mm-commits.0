From: akpm@linux-foundation.org
Subject: + git-v4l-dvb-git-rejects.patch added to -mm tree
Date: Wed, 01 Oct 2008 15:18:50 -0700
Message-ID: <200810012218.m91MIoXi007090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752003AbYJAWSw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 18:18:52 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m91MIorL000505
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 1 Oct 2008 15:18:51 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     git-v4l-dvb-git-rejects
has been added to the -mm tree.  Its filename is
     git-v4l-dvb-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-v4l-dvb-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/Kconfig |   63 ----------------------------------
 1 file changed, 63 deletions(-)

diff -puN drivers/media/video/Kconfig~git-v4l-dvb-git-rejects drivers/media/video/Kconfig
--- a/drivers/media/video/Kconfig~git-v4l-dvb-git-rejects
+++ a/drivers/media/video/Kconfig
@@ -956,67 +956,4 @@ config USB_S2255
 
 endif # V4L_USB_DRIVERS
 
-<<<<<<< HEAD:drivers/media/video/Kconfig
-config SOC_CAMERA
-	tristate "SoC camera support"
-	depends on VIDEO_V4L2 && HAS_DMA
-	select VIDEOBUF_GEN
-	help
-	  SoC Camera is a common API to several cameras, not connecting
-	  over a bus like PCI or USB. For example some i2c camera connected
-	  directly to the data bus of an SoC.
-
-config SOC_CAMERA_MT9M001
-	tristate "mt9m001 support"
-	depends on SOC_CAMERA && I2C
-	select GPIO_PCA953X if MT9M001_PCA9536_SWITCH
-	help
-	  This driver supports MT9M001 cameras from Micron, monochrome
-	  and colour models.
-
-config MT9M001_PCA9536_SWITCH
-	bool "pca9536 datawidth switch for mt9m001"
-	depends on SOC_CAMERA_MT9M001 && GENERIC_GPIO
-	help
-	  Select this if your MT9M001 camera uses a PCA9536 I2C GPIO
-	  extender to switch between 8 and 10 bit datawidth modes
-
-config SOC_CAMERA_MT9V022
-	tristate "mt9v022 support"
-	depends on SOC_CAMERA && I2C
-	select GPIO_PCA953X if MT9V022_PCA9536_SWITCH
-	help
-	  This driver supports MT9V022 cameras from Micron
-
-config MT9V022_PCA9536_SWITCH
-	bool "pca9536 datawidth switch for mt9v022"
-	depends on SOC_CAMERA_MT9V022 && GENERIC_GPIO
-	help
-	  Select this if your MT9V022 camera uses a PCA9536 I2C GPIO
-	  extender to switch between 8 and 10 bit datawidth modes
-
-config SOC_CAMERA_PLATFORM
-	tristate "platform camera support"
-	depends on SOC_CAMERA
-	help
-	  This is a generic SoC camera platform driver, useful for testing
-
-config VIDEO_PXA27x
-	tristate "PXA27x Quick Capture Interface driver"
-	depends on VIDEO_DEV && PXA27x
-	select SOC_CAMERA
-	select VIDEOBUF_DMA_SG
-	---help---
-	  This is a v4l2 driver for the PXA27x Quick Capture Interface
-
-config VIDEO_SH_MOBILE_CEU
-	tristate "SuperH Mobile CEU Interface driver"
-	depends on VIDEO_DEV && HAS_DMA
-	select SOC_CAMERA
-	select VIDEOBUF_DMA_CONTIG
-	---help---
-	  This is a v4l2 driver for the SuperH Mobile CEU Interface
-
-=======
->>>>>>> FETCH_HEAD:drivers/media/video/Kconfig
 endif # VIDEO_CAPTURE_DRIVERS
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

git-powerpc.patch
git-sparc.patch
git-x86.patch
git-x86-git-rejects.patch
git-xtensa.patch
git-ftrace.patch
git-pci.patch
git-hid.patch
git-v4l-dvb.patch
git-v4l-dvb-git-rejects.patch
git-nfsd.patch
git-dlm.patch
git-async_tx.patch
git-net.patch
git-mtd.patch
git-sound.patch
git-sound-rejects.patch
git-input.patch
git-block.patch
git-battery.patch
git-mfd.patch
git-drm.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
arch-x86-kernel-early_printkc-remove-unused-enable_debug_console.patch
drivers-media-video-tda9840c-unbreak.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver.patch
misdn-misc-timerdev-fixes-fix.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
drivers-scsi-sdh-use-inlined-c-functions-not-macros.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
acpi-cope-with-pnpacpi-tables-missing-an-rtc-entry.patch
drivers-media-video-cafe_ccicc-needs-mmh.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
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
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
eeepc-laptop-use-standard-interfaces-fix-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix.patch
make-taint-bit-reliable-v3-fix.patch
kernel-sysc-improve-code-generation.patch
compat-generic-compat-get-settimeofday-checkpatch-fixes.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
allow-recursion-in-binfmt_script-and-binfmt_misc-fix.patch
serial-make-uart_ports-ioport-unsigned-long-fix.patch
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
ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch-fixes.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
tty-fix-echo-tab-erase-and-locking-fix.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves-fix.patch
w1-new-driver-ds2431-chip-fix.patch
gru-driver-minor-updates-fix.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-3.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
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

