From: akpm@linux-foundation.org
Subject: - include-linux-nfsd-consth-remove-nfs_super_magic.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:46:58 -0800
Message-ID: <200702122246.l1CMkwkO013872@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45728 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030390AbXBLWuO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:50:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     include/linux/nfsd/const.h: remove NFS_SUPER_MAGIC
has been removed from the -mm tree.  Its filename was
     include-linux-nfsd-consth-remove-nfs_super_magic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: include/linux/nfsd/const.h: remove NFS_SUPER_MAGIC
From: Adrian Bunk <bunk@stusta.de>

NFS_SUPER_MAGIC is already defined in include/linux/magic.h

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/super.c             |    1 +
 include/linux/nfsd/const.h |    4 ----
 2 files changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/nfs/super.c~include-linux-nfsd-consth-remove-nfs_super_magic fs/nfs/super.c
--- a/fs/nfs/super.c~include-linux-nfsd-consth-remove-nfs_super_magic
+++ a/fs/nfs/super.c
@@ -44,6 +44,7 @@
 #include <linux/vfs.h>
 #include <linux/inet.h>
 #include <linux/nfs_xdr.h>
+#include <linux/magic.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
diff -puN include/linux/nfsd/const.h~include-linux-nfsd-consth-remove-nfs_super_magic include/linux/nfsd/const.h
--- a/include/linux/nfsd/const.h~include-linux-nfsd-consth-remove-nfs_super_magic
+++ a/include/linux/nfsd/const.h
@@ -30,10 +30,6 @@
 
 #include <linux/sunrpc/msg_prot.h>
 
-#ifndef NFS_SUPER_MAGIC
-# define NFS_SUPER_MAGIC	0x6969
-#endif
-
 /*
  * Largest number of bytes we need to allocate for an NFS
  * call or reply.  Used to control buffer sizes.  We use
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
