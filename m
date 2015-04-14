From: akpm@linux-foundation.org
Subject: [folded-merged] mm-cma-release-trigger-checkpatch-fixes.patch
 removed from -mm tree
Date: Tue, 14 Apr 2015 15:13:05 -0700
Message-ID: <552d90f1.WRyItftqRM1pcpNo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54274 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbbDNWNG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Apr 2015 18:13:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-release-trigger-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-cma-release-trigger-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-cma-release-trigger.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-cma-release-trigger-checkpatch-fixes

ERROR: code indent should use tabs where possible
#76: FILE: mm/cma_debug.c:88:
+        int pages = val;$

WARNING: please, no spaces at the start of a line
#76: FILE: mm/cma_debug.c:88:
+        int pages = val;$

ERROR: code indent should use tabs where possible
#79: FILE: mm/cma_debug.c:91:
+        return cma_free_mem(cma, pages);$

WARNING: please, no spaces at the start of a line
#79: FILE: mm/cma_debug.c:91:
+        return cma_free_mem(cma, pages);$

total: 2 errors, 2 warnings, 69 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/mm-cma-release-trigger.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma_debug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/cma_debug.c~mm-cma-release-trigger-checkpatch-fixes mm/cma_debug.c
--- a/mm/cma_debug.c~mm-cma-release-trigger-checkpatch-fixes
+++ a/mm/cma_debug.c
@@ -85,10 +85,10 @@ static int cma_free_mem(struct cma *cma,
 
 static int cma_free_write(void *data, u64 val)
 {
-        int pages = val;
+	int pages = val;
 	struct cma *cma = data;
 
-        return cma_free_mem(cma, pages);
+	return cma_free_mem(cma, pages);
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(cma_free_fops, NULL, cma_free_write, "%llu\n");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ocfs2-make-mlog_errno-return-the-errno.patch
mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473.patch
mm-cma-release-trigger.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch

