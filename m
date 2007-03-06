From: akpm@linux-foundation.org
Subject: - filesystem-disk-errors-at-boot-time-caused-by-probe-fix.patch removed from -mm tree
Date: Mon, 05 Mar 2007 16:57:01 -0800
Message-ID: <200703060057.l260v2jr006888@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43746 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbXCFBAZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:00:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     make fs/partitions/msdos.c:check_sane_values() static
has been removed from the -mm tree.  Its filename was
     filesystem-disk-errors-at-boot-time-caused-by-probe-fix.patch

This patch was dropped because it was folded into filesystem-disk-errors-at-boot-time-caused-by-probe.patch

------------------------------------------------------
Subject: make fs/partitions/msdos.c:check_sane_values() static
From: Adrian Bunk <bunk@stusta.de>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/msdos.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/partitions/msdos.c~filesystem-disk-errors-at-boot-time-caused-by-probe-fix fs/partitions/msdos.c
--- a/fs/partitions/msdos.c~filesystem-disk-errors-at-boot-time-caused-by-probe-fix
+++ a/fs/partitions/msdos.c
@@ -431,7 +431,7 @@ static struct {
  *
  * Copyright 31 January 2007, TJ <linux@tjworld.net>
  */
-int check_sane_values(struct partition *p, struct block_device *bdev)
+static int check_sane_values(struct partition *p, struct block_device *bdev)
 {
 	unsigned char *data;
 	struct partition *ext;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
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
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
lguest-kconfig-and-headers-fix.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
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
