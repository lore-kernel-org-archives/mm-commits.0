From: akpm@osdl.org
Subject: - include-scsi-libsash-should-include-linux-scatterlisth.patch removed from -mm tree
Date: Fri, 08 Dec 2006 03:04:52 -0800
Message-ID: <200612081104.kB8B4qLO018595@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49299 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938032AbWLHLIa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 06:08:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, James.Bottomley@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     include/scsi/libsas.h should #include <linux/scatterlist.h>
has been removed from the -mm tree.  Its filename was
     include-scsi-libsash-should-include-linux-scatterlisth.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: include/scsi/libsas.h should #include <linux/scatterlist.h>
From: Adrian Bunk <bunk@stusta.de>

In file included from drivers/scsi/sas/sas_internal.h:31,
                 from drivers/scsi/sas/sas_init.c:35:
include/scsi/libsas.h:479: error: field 'smp_req' has incomplete type
include/scsi/libsas.h:480: error: field 'smp_resp' has incomplete type

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/scsi/libsas.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/scsi/libsas.h~include-scsi-libsash-should-include-linux-scatterlisth include/scsi/libsas.h
--- a/include/scsi/libsas.h~include-scsi-libsash-should-include-linux-scatterlisth
+++ a/include/scsi/libsas.h
@@ -31,6 +31,7 @@
 #include <linux/pci.h>
 #include <scsi/sas.h>
 #include <linux/list.h>
+#include <linux/scatterlist.h>
 #include <asm/semaphore.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
generic-bug-implementation.patch
fsstack-introduce-fsstack_copy_attrinode_.patch
i4l-remove-the-broken-hisax_amd7930-option.patch
make-drivers-md-dm-snapcksnapd-static.patch
make-drivers-acpi-eccec_ecdt-static.patch
drivers-acpi-oslc-fix-a-null-check.patch
git-alsa.patch
git-dvb.patch
fs-dlm-lowcomms-tcpc-remove-2-functions.patch
git-mtd.patch
remove-mtd-jffs2-userh.patch
git-net.patch
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
make-ext2_get_blocks-static.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
gtod-persistent-clock-support-core-remove-kernel-timercwall_jiffies.patch
gtod-persistent-clock-support-i386-i386-unexport-read_persistent_clock.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-make-kernel-timerc__next_timer_interrupt-static.patch
updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static.patch
updated-i386-convert-to-clock-event-devices-remove-arch-i386-kernel-time_hpetchpet_reenable.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slab-cache-shrinker-statistics.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

