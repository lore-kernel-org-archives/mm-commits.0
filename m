From: akpm@osdl.org
Subject: - gtod-persistent-clock-support-i386-i386-unexport-read_persistent_clock.patch removed from -mm tree
Date: Wed, 13 Dec 2006 14:48:20 -0800
Message-ID: <200612132248.kBDMmK6a023058@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53321 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbWLMWvg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:51:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     i386: unexport read_persistent_clock
has been removed from the -mm tree.  Its filename was
     gtod-persistent-clock-support-i386-i386-unexport-read_persistent_clock.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: i386: unexport read_persistent_clock
From: Adrian Bunk <bunk@stusta.de>

This patch removes the unused EXPORT_SYMBOL(read_persistent_clock).

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/time.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/i386/kernel/time.c~gtod-persistent-clock-support-i386-i386-unexport-read_persistent_clock arch/i386/kernel/time.c
--- a/arch/i386/kernel/time.c~gtod-persistent-clock-support-i386-i386-unexport-read_persistent_clock
+++ a/arch/i386/kernel/time.c
@@ -227,7 +227,6 @@ unsigned long read_persistent_clock(void
 
 	return retval;
 }
-EXPORT_SYMBOL(read_persistent_clock);
 
 static void sync_cmos_clock(unsigned long dummy);
 
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
debug-add-sysrq_always_enabled-boot-option.patch
one-more-export_unused_symbol-removal.patch
remove-the-broken-blk_dev_swim_iop-driver.patch
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
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

