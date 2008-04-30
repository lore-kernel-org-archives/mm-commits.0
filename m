From: akpm@linux-foundation.org
Subject: - mm-bdi-export-bdi_writeout_inc-fix.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:21:23 -0700
Message-ID: <200804300621.m3U6LOsb031518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754806AbYD3GV7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:21:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     mm: bdi: export bdi_writeout_inc() fix
has been removed from the -mm tree.  Its filename was
     mm-bdi-export-bdi_writeout_inc-fix.patch

This patch was dropped because it was folded into mm-bdi-export-bdi_writeout_inc.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: bdi: export bdi_writeout_inc() fix
From: Miklos Szeredi <mszeredi@suse.cz>


Make bdi_writeout_inc() GPL only at the request of Peter Zijlstra.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/mm/page-writeback.c
===================================================================
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page-writeback.c~mm-bdi-export-bdi_writeout_inc-fix mm/page-writeback.c
--- a/mm/page-writeback.c~mm-bdi-export-bdi_writeout_inc-fix
+++ a/mm/page-writeback.c
@@ -176,7 +176,7 @@ void bdi_writeout_inc(struct backing_dev
 	__bdi_writeout_inc(bdi);
 	local_irq_restore(flags);
 }
-EXPORT_SYMBOL(bdi_writeout_inc);
+EXPORT_SYMBOL_GPL(bdi_writeout_inc);
 
 static inline void task_dirty_inc(struct task_struct *tsk)
 {
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-move-statistics-to-debugfs.patch
mm-bdi-add-separate-writeback-accounting-capability.patch
mm-bdi-export-bdi_writeout_inc.patch
mm-bdi-export-bdi_writeout_inc-fix.patch
mm-add-nr_writeback_temp-counter.patch
mm-add-nr_writeback_temp-counter-fix.patch
mm-document-missing-fields-for-proc-meminfo.patch
fuse-support-writable-mmap.patch
fuse-support-writable-mmap-fix.patch
fuse-clean-up-setting-i_size-in-write.patch
fuse-implement-perform_write.patch
fuse-update-file-size-on-short-read.patch
fuse-update-file-size-on-short-read-fix.patch
fuse-fix-max-i-o-size-calculation.patch
fuse-fix-node-id-type.patch
fuse-fix-race-in-llseek.patch
fuse-fix-race-in-llseek-fix.patch
fuse-fix-sparse-warnings.patch

