From: akpm@linux-foundation.org
Subject: - correct-config_gigaset_m101-makefile-entry.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:13:12 -0800
Message-ID: <200702170713.l1H7DCLT021439@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51312 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946577AbXBQHTg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:19:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, tilman@imap.cc, mm-commits@vger.kernel.org


The patch titled
     correct CONFIG_GIGASET_M101 Makefile entry
has been removed from the -mm tree.  Its filename was
     correct-config_gigaset_m101-makefile-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: correct CONFIG_GIGASET_M101 Makefile entry
From: Adrian Bunk <bunk@stusta.de>

Advanced Mathematics, lesson 1:
101 != 105

;-)

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/gigaset/Makefile~correct-config_gigaset_m101-makefile-entry drivers/isdn/gigaset/Makefile
--- a/drivers/isdn/gigaset/Makefile~correct-config_gigaset_m101-makefile-entry
+++ a/drivers/isdn/gigaset/Makefile
@@ -5,4 +5,4 @@ ser_gigaset-y := ser-gigaset.o asyncdata
 
 obj-$(CONFIG_GIGASET_M105) += usb_gigaset.o gigaset.o
 obj-$(CONFIG_GIGASET_BASE) += bas_gigaset.o gigaset.o
-obj-$(CONFIG_GIGASET_M105) += ser_gigaset.o gigaset.o
+obj-$(CONFIG_GIGASET_M101) += ser_gigaset.o gigaset.o
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
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
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
lumpy-reclaim-cleanup.patch
drivers-isdn-gigaset-build-asyncdatao-into-the-gigaset-module.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
linux-kernel-markers-kconfig-menus-fix.patch
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
