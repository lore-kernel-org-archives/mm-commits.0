From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 14 Dec 2009 12:54:00 -0800
Message-ID: <200912142054.nBEKs1oI005505@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932181AbZLNUyG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 15:54:06 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id nBEKs1Bf014676
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 14 Dec 2009 12:54:02 -0800
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

 MAINTAINERS                             |   10 ----------
 arch/arm/configs/omap_3430sdp_defconfig |    3 ---
 arch/arm/mach-omap2/board-3430sdp.c     |   11 -----------
 arch/arm/mach-omap2/io.c                |    3 ---
 arch/arm/plat-omap/fb.c                 |    3 ---
 drivers/gpu/drm/drm_fb_helper.c         |    4 ----
 drivers/video/omap2/displays/Kconfig    |    3 ---
 drivers/video/omap2/displays/Makefile   |    3 ---
 8 files changed, 40 deletions(-)

diff -puN MAINTAINERS~linux-next-git-rejects MAINTAINERS
--- a/MAINTAINERS~linux-next-git-rejects
+++ a/MAINTAINERS
@@ -3963,13 +3963,8 @@ F:	drivers/video/omap/
 
 OMAP DISPLAY SUBSYSTEM SUPPORT (DSS2)
 M:	Tomi Valkeinen <tomi.valkeinen@nokia.com>
-<<<<<<< HEAD:MAINTAINERS
-L:	linux-omap@vger.kernel.org
-L:	linux-fbdev@vger.kernel.org (moderated for non-subscribers)
-=======
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 L:	linux-omap@vger.kernel.org
->>>>>>> FETCH_HEAD:MAINTAINERS
 S:	Maintained
 F:	drivers/video/omap2/dss/
 F:	drivers/video/omap2/vrfb.c
@@ -3978,13 +3973,8 @@ F:	Documentation/arm/OMAP/DSS
 
 OMAP FRAMEBUFFER SUPPORT (FOR DSS2)
 M:	Tomi Valkeinen <tomi.valkeinen@nokia.com>
-<<<<<<< HEAD:MAINTAINERS
-L:	linux-omap@vger.kernel.org
-L:	linux-fbdev@vger.kernel.org (moderated for non-subscribers)
-=======
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 L:	linux-omap@vger.kernel.org
->>>>>>> FETCH_HEAD:MAINTAINERS
 S:	Maintained
 F:	drivers/video/omap2/omapfb/
 
diff -puN arch/arm/configs/omap_3430sdp_defconfig~linux-next-git-rejects arch/arm/configs/omap_3430sdp_defconfig
--- a/arch/arm/configs/omap_3430sdp_defconfig~linux-next-git-rejects
+++ a/arch/arm/configs/omap_3430sdp_defconfig
@@ -988,10 +988,7 @@ CONFIG_FB_OMAP2_NUM_FBS=3
 # OMAP2/3 Display Device Drivers
 #
 CONFIG_PANEL_GENERIC=y
-<<<<<<< HEAD:arch/arm/configs/omap_3430sdp_defconfig
-=======
 # CONFIG_PANEL_SAMSUNG_LTE430WQ_F0C is not set
->>>>>>> FETCH_HEAD:arch/arm/configs/omap_3430sdp_defconfig
 CONFIG_PANEL_SHARP_LS037V7DW01=y
 # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
diff -puN arch/arm/mach-omap2/board-3430sdp.c~linux-next-git-rejects arch/arm/mach-omap2/board-3430sdp.c
--- a/arch/arm/mach-omap2/board-3430sdp.c~linux-next-git-rejects
+++ a/arch/arm/mach-omap2/board-3430sdp.c
@@ -273,7 +273,6 @@ static struct omap_dss_device *sdp3430_d
 	&sdp3430_lcd_device,
 	&sdp3430_dvi_device,
 	&sdp3430_tv_device,
-<<<<<<< HEAD:arch/arm/mach-omap2/board-3430sdp.c
 };
 
 static struct omap_dss_board_info sdp3430_dss_data = {
@@ -282,16 +281,6 @@ static struct omap_dss_board_info sdp343
 	.default_device	= &sdp3430_lcd_device,
 };
 
-=======
-};
-
-static struct omap_dss_board_info sdp3430_dss_data = {
-	.num_devices	= ARRAY_SIZE(sdp3430_dss_devices),
-	.devices	= sdp3430_dss_devices,
-	.default_device	= &sdp3430_lcd_device,
-};
-
->>>>>>> FETCH_HEAD:arch/arm/mach-omap2/board-3430sdp.c
 static struct platform_device sdp3430_dss_device = {
 	.name		= "omapdss",
 	.id		= -1,
diff -puN arch/arm/mach-omap2/io.c~linux-next-git-rejects arch/arm/mach-omap2/io.c
--- a/arch/arm/mach-omap2/io.c~linux-next-git-rejects
+++ a/arch/arm/mach-omap2/io.c
@@ -33,10 +33,7 @@
 #include <plat/sdrc.h>
 #include <plat/gpmc.h>
 #include <plat/serial.h>
-<<<<<<< HEAD:arch/arm/mach-omap2/io.c
-=======
 #include <plat/mux.h>
->>>>>>> FETCH_HEAD:arch/arm/mach-omap2/io.c
 #include <plat/vram.h>
 
 #ifndef CONFIG_ARCH_OMAP4	/* FIXME: Remove this once clkdev is ready */
diff -puN arch/arm/plat-omap/fb.c~linux-next-git-rejects arch/arm/plat-omap/fb.c
--- a/arch/arm/plat-omap/fb.c~linux-next-git-rejects
+++ a/arch/arm/plat-omap/fb.c
@@ -371,13 +371,10 @@ unsigned long omapfb_reserve_sram(unsign
 
 #else
 
-<<<<<<< HEAD:arch/arm/plat-omap/fb.c
 void omapfb_set_platform_data(struct omapfb_platform_data *data)
 {
 }
 
-=======
->>>>>>> FETCH_HEAD:arch/arm/plat-omap/fb.c
 void omapfb_reserve_sdram(void) {}
 unsigned long omapfb_reserve_sram(unsigned long sram_pstart,
 				  unsigned long sram_vstart,
diff -puN drivers/gpu/drm/drm_fb_helper.c~linux-next-git-rejects drivers/gpu/drm/drm_fb_helper.c
--- a/drivers/gpu/drm/drm_fb_helper.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/drm_fb_helper.c
@@ -908,11 +908,7 @@ int drm_fb_helper_single_fb_probe(struct
 
 	if (new_fb) {
 		info->var.pixclock = 0;
-<<<<<<< HEAD:drivers/gpu/drm/drm_fb_helper.c
-		ret = fb_alloc_cmap(&info->cmap, modeset->crtc->gamma_size, 0);
-=======
 		ret = fb_alloc_cmap(&info->cmap, crtc->gamma_size, 0);
->>>>>>> FETCH_HEAD:drivers/gpu/drm/drm_fb_helper.c
 		if (ret)
 			return ret;
 		if (register_framebuffer(info) < 0) {
diff -puN drivers/video/omap2/displays/Kconfig~linux-next-git-rejects drivers/video/omap2/displays/Kconfig
--- a/drivers/video/omap2/displays/Kconfig~linux-next-git-rejects
+++ a/drivers/video/omap2/displays/Kconfig
@@ -7,15 +7,12 @@ config PANEL_GENERIC
 	  Generic panel driver.
 	  Used for DVI output for Beagle and OMAP3 SDP.
 
-<<<<<<< HEAD:drivers/video/omap2/displays/Kconfig
-=======
 config PANEL_SAMSUNG_LTE430WQ_F0C
         tristate "Samsung LTE430WQ-F0C LCD Panel"
         depends on OMAP2_DSS
         help
           LCD Panel used on Overo Palo43
 
->>>>>>> FETCH_HEAD:drivers/video/omap2/displays/Kconfig
 config PANEL_SHARP_LS037V7DW01
         tristate "Sharp LS037V7DW01 LCD Panel"
         depends on OMAP2_DSS
diff -puN drivers/video/omap2/displays/Makefile~linux-next-git-rejects drivers/video/omap2/displays/Makefile
--- a/drivers/video/omap2/displays/Makefile~linux-next-git-rejects
+++ a/drivers/video/omap2/displays/Makefile
@@ -1,8 +1,5 @@
 obj-$(CONFIG_PANEL_GENERIC) += panel-generic.o
-<<<<<<< HEAD:drivers/video/omap2/displays/Makefile
-=======
 obj-$(CONFIG_PANEL_SAMSUNG_LTE430WQ_F0C) += panel-samsung-lte430wq-f0c.o
->>>>>>> FETCH_HEAD:drivers/video/omap2/displays/Makefile
 obj-$(CONFIG_PANEL_SHARP_LS037V7DW01) += panel-sharp-ls037v7dw01.o
 
 obj-$(CONFIG_PANEL_TAAL) += panel-taal.o
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
acpi-remove-nid_inval.patch
drivers-acpi-acpi_padc-squish-warning.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
drivers-leds-leds-ss4200c-fix-return-statement.patch
net-sctp-socketc-fix-warning.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
scsi-aacraid-fix-memory-leak-checkpatch-fixes.patch
aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
ksm-memory-hotremove-migration-only-fix.patch
mm-memory_hotplug-make-offline_pages-static.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore-cleanup.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore-build-fix.patch
mm-hugetlb-add-hugepage-support-to-pagemap-build-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-cleanup.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
drivers-scsi-sym53c8xx_2-sym_gluec-rename-skip_spaces-to-sym_skip_spaces.patch
lib-introduce-strim-checkpatch-fixes.patch
msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes.patch
blackfin-sd-host-controller-driver-fix.patch
blackfin-sd-host-controller-driver-fix-fix.patch
blackfin-sd-host-controller-driver-fix-fix-fix.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
lis3-update-documentation-to-match-latest-changes-fix.patch
spi-controller-driver-for-designware-spi-core-fix.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2-fix-3.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit-cleanup.patch
ipc-remove-unreachable-code-in-semc-fix.patch
char-cyclades-fix-compiler-warning.patch
fs-cache-avoid-maybe-used-uninitialised-warning-on-variable.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-media-video-cx23885-needs-kfifo-updates.patch
revert-tty-sdio_uart-use-kfifo-instead-of-the-messy-circ-stuff.patch
kfifo-move-struct-kfifo-in-place-fix.patch
zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes-cleanup.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

