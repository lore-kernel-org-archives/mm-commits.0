From: akpm@linux-foundation.org
Subject: + make-dvb_usb_gl861_debug-static.patch added to -mm tree
Date: Wed, 21 Feb 2007 14:08:08 -0800
Message-ID: <200702212208.l1LM88Vi027857@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51436 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965010AbXBUWLa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 17:11:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, mchehab@infradead.org


The patch titled
     make dvb_usb_gl861_debug static
has been added to the -mm tree.  Its filename is
     make-dvb_usb_gl861_debug-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make dvb_usb_gl861_debug static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-usb/gl861.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/dvb/dvb-usb/gl861.c~make-dvb_usb_gl861_debug-static drivers/media/dvb/dvb-usb/gl861.c
--- a/drivers/media/dvb/dvb-usb/gl861.c~make-dvb_usb_gl861_debug-static
+++ a/drivers/media/dvb/dvb-usb/gl861.c
@@ -12,7 +12,7 @@
 #include "qt1010.h"
 
 /* debug */
-int dvb_usb_gl861_debug;
+static int dvb_usb_gl861_debug;
 module_param_named(debug,dvb_usb_gl861_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=rc (or-able))." DVB_USB_DEBUG_STATUS);
 
_

Patches currently in -mm which might be from bunk@stusta.de are

arch-arm26-kernel-entrys-remove-dead-code.patch
git-cpufreq.patch
git-drm.patch
git-dvb.patch
make-dvb_usb_gl861_debug-static.patch
git-ieee1394.patch
mips-remove-smp_tune_scheduling.patch
remove-fs-jffs2-ioctlc.patch
git-ubi.patch
drivers-net-vioc-possible-cleanups.patch
git-net.patch
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
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
lumpy-reclaim-cleanup.patch
kill-net-rxrpc-rxrpc_symsc.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
linux-kernel-markers-kconfig-menus-fix.patch
linux-kernel-markers-architecture-independant-code-license-fix.patch
linux-kernel-markers-i386-optimization-export-fix.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
