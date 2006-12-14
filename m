From: akpm@osdl.org
Subject: - one-more-export_unused_symbol-removal.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:14:03 -0800
Message-ID: <200612140614.kBE6E3mK002145@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52653 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbWLNGR0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:17:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     one more EXPORT_UNUSED_SYMBOL removal
has been removed from the -mm tree.  Its filename was
     one-more-export_unused_symbol-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: one more EXPORT_UNUSED_SYMBOL removal
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/read_write.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/read_write.c~one-more-export_unused_symbol-removal fs/read_write.c
--- a/fs/read_write.c~one-more-export_unused_symbol-removal
+++ a/fs/read_write.c
@@ -450,8 +450,6 @@ unsigned long iov_shorten(struct iovec *
 	return seg;
 }
 
-EXPORT_UNUSED_SYMBOL(iov_shorten);  /*  June 2006  */
-
 ssize_t do_sync_readv_writev(struct file *filp, const struct iovec *iov,
 		unsigned long nr_segs, size_t len, loff_t *ppos, iov_fn_t fn)
 {
_

Patches currently in -mm which might be from bunk@stusta.de are

make-drivers-acpi-eccec_ecdt-static.patch
drivers-acpi-oslc-fix-a-null-check.patch
acpi-make-code-static.patch
git-alsa.patch
proper-prototype-for-drivers-base-initcdriver_init.patch
fs-dlm-lowcomms-tcpc-remove-2-functions.patch
git-mtd.patch
remove-the-broken-skmc-driver.patch
net-uninline-skb_put-fix.patch
dont-export-device-ids-to-userspace.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
drivers-edac-make-code-static.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
remove-include-linux-byteorder-pdp_endianh.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i386-drivers.patch
make-ext2_get_blocks-static.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
remove-broken-video-drivers-v4.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

