From: akpm@linux-foundation.org
Subject: [alternative-merged] drivers-leds-leds-ss4200c-fix-return-statement.patch removed from -mm tree
Date: Fri, 18 Dec 2009 12:25:14 -0800
Message-ID: <200912182025.nBIKPEr4016407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932757AbZLRUZ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 15:25:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@sr71.net, rpurdie@rpsys.net, tfransosi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/leds/leds-ss4200.c: fix return statement
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-ss4200c-fix-return-statement.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/leds/leds-ss4200.c: fix return statement
From: Andrew Morton <akpm@linux-foundation.org>

drivers/leds/leds-ss4200.c: In function 'ich7_lpc_probe':
drivers/leds/leds-ss4200.c:353: warning: 'return' with no value, in function returning non-void

Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Dave Hansen <dave@sr71.net>
Cc: Thiago Farina <tfransosi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-ss4200.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-ss4200.c~drivers-leds-leds-ss4200c-fix-return-statement drivers/leds/leds-ss4200.c
--- a/drivers/leds/leds-ss4200.c~drivers-leds-leds-ss4200c-fix-return-statement
+++ a/drivers/leds/leds-ss4200.c
@@ -350,7 +350,7 @@ static int __devinit ich7_lpc_probe(stru
 	status = pci_enable_device(dev);
 	if (status) {
 		dev_err(&dev->dev, "pci_enable_device failed\n");
-		return;
+		return status;
 	}
 
 	nas_gpio_pci_dev = dev;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kfifo-move-struct-kfifo-in-place-fix.patch
linux-next.patch
linux-next-fixup.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-tools-chkobjdumpawk-fix-it.patch
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

