From: akpm@linux-foundation.org
Subject: [folded] drivers-media-video-cx23885-needs-kfifo-updates.patch removed from -mm tree
Date: Thu, 17 Dec 2009 14:57:41 -0800
Message-ID: <200912172257.nBHMvf7V023572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750987AbZLQW6W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Dec 2009 17:58:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, stefani@seibold.net, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video/cx23885: needs kfifo updates
has been removed from the -mm tree.  Its filename was
     drivers-media-video-cx23885-needs-kfifo-updates.patch

This patch was dropped because it was folded into drivers-media-video-cx23885-needs-kfifo-conversion.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video/cx23885: needs kfifo updates
From: Andrew Morton <akpm@linux-foundation.org>

linux-next again.

Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cx23885/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/media/video/cx23885/Makefile~a drivers/media/video/cx23885/Makefile
diff -puN drivers/media/video/cx23885/Kconfig~a drivers/media/video/cx23885/Kconfig
--- a/drivers/media/video/cx23885/Kconfig~a
+++ a/drivers/media/video/cx23885/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_CX23885
 	tristate "Conexant cx23885 (2388x successor) support"
 	depends on DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT
+	depends on BROKEN
 	select I2C_ALGOBIT
 	select VIDEO_BTCX
 	select VIDEO_TUNER
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
readahead-add-blk_run_backing_dev.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-media-video-cx23885-needs-kfifo-updates.patch
kfifo-move-struct-kfifo-in-place-fix.patch
linux-next.patch
linux-next-fixup.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
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
fs-ext4-superc-fix-printk-warning.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
scsi-aacraid-fix-memory-leak-checkpatch-fixes.patch
aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch
fs-improve-remountro-vs-buffercache-coherency.patch
drivers-net-wireless-iwlwifi-iwl-txc-fix-gcc-345-warning.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
spi-controller-driver-for-designware-spi-core.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array.patch
char-cyclades-fix-compiler-warning.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch
lib-add-support-for-lzo-compressed-kernels.patch
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

