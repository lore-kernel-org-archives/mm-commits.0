From: akpm@linux-foundation.org
Subject: - proper-prototype-for-tosh_smm.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:49:38 -0800
Message-ID: <200702122249.l1CMnc7U014140@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45948 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030436AbXBLWw7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:52:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     proper prototype for tosh_smm()
has been removed from the -mm tree.  Its filename was
     proper-prototype-for-tosh_smm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: proper prototype for tosh_smm()
From: Adrian Bunk <bunk@stusta.de>

Add a proper prototype for tosh_smm() to include/linux/toshiba.h

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/neofb.c   |    1 -
 include/linux/toshiba.h |    2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/neofb.c~proper-prototype-for-tosh_smm drivers/video/neofb.c
--- a/drivers/video/neofb.c~proper-prototype-for-tosh_smm
+++ a/drivers/video/neofb.c
@@ -66,7 +66,6 @@
 #include <linux/init.h>
 #ifdef CONFIG_TOSHIBA
 #include <linux/toshiba.h>
-extern int tosh_smm(SMMRegisters *regs);
 #endif
 
 #include <asm/io.h>
diff -puN include/linux/toshiba.h~proper-prototype-for-tosh_smm include/linux/toshiba.h
--- a/include/linux/toshiba.h~proper-prototype-for-tosh_smm
+++ a/include/linux/toshiba.h
@@ -33,4 +33,6 @@ typedef struct {
 	unsigned int edi __attribute__ ((packed));
 } SMMRegisters;
 
+int tosh_smm(SMMRegisters *regs);
+
 #endif
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
ifdef-acpi_future_usage-acpi_os_readable.patch
git-cpufreq.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
mips-remove-smp_tune_scheduling.patch
git-mtd.patch
git-ubi.patch
net-uninline-skb_put-fix.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
git-unionfs.patch
usb_rtl8150-must-select-mii.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
lumpy-reclaim-cleanup.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i383-drivers.patch
add-debugging-feature-proc-timer_stat-cleanup.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
sysctl-reimplement-the-sysctl-proc-support-fix-3.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
