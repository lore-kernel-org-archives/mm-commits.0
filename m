From: akpm@linux-foundation.org
Subject: - make-dvb_usb_gl861_debug-static.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:51:46 -0800
Message-ID: <200702282351.l1SNpkQO030943@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48601 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932785AbXB1X4S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:56:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mchehab@infradead.org, mkrufky@linuxtv.org, mm-commits@vger.kernel.org


The patch titled
     make dvb_usb_gl861_debug static
has been removed from the -mm tree.  Its filename was
     make-dvb_usb_gl861_debug-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make dvb_usb_gl861_debug static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Acked-by: Michael Krufky <mkrufky@linuxtv.org>
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
make-ipc-shmcshm_nopage-static.patch
mm-tiny-shmemc-cleanups.patch
drivers-video-sm501fbc-make-4-functions-static.patch
fix-the-sysctl=n-compilation.patch
drivers-isdn-gigaset-build-asyncdatao-into-the-gigaset-module-fix.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-hid.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
drivers-mmc-kconfig-source-drivers-mmc-card-kconfig.patch
remove-fs-jffs2-ioctlc.patch
git-ubi.patch
drivers-net-vioc-possible-cleanups.patch
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
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
lguest-kconfig-and-headers-fix.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
lumpy-reclaim-cleanup.patch
filesystem-disk-errors-at-boot-time-caused-by-probe-fix.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
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
