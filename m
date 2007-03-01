From: akpm@linux-foundation.org
Subject: - drivers-mmc-kconfig-source-drivers-mmc-card-kconfig.patch removed from -mm tree
Date: Wed, 28 Feb 2007 16:50:41 -0800
Message-ID: <200703010052.l210qGXG032446@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49913 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932859AbXCAAzs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 19:55:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, drzeus-list@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     drivers/mmc/Kconfig source drivers/mmc/card/Kconfig
has been removed from the -mm tree.  Its filename was
     drivers-mmc-kconfig-source-drivers-mmc-card-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/mmc/Kconfig source drivers/mmc/card/Kconfig
From: Adrian Bunk <bunk@stusta.de>

The MMC_BLOCK option was accidentally lost.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/Kconfig |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/mmc/Kconfig~drivers-mmc-kconfig-source-drivers-mmc-card-kconfig drivers/mmc/Kconfig
--- a/drivers/mmc/Kconfig~drivers-mmc-kconfig-source-drivers-mmc-card-kconfig
+++ a/drivers/mmc/Kconfig
@@ -19,6 +19,7 @@ config MMC_DEBUG
 	  This is an option for use by developers; most people should
 	  say N here.  This enables MMC core and driver debugging.
 
+source "drivers/mmc/card/Kconfig"
 source "drivers/mmc/host/Kconfig"
 
 endmenu
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
