From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch removed
 from -mm tree
Date: Tue, 14 Apr 2015 15:16:59 -0700
Message-ID: <552d91db.nDGKFQ1X39NT29kw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54320 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbbDNWRA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Apr 2015 18:17:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-clarify-__gfp_nofail-deprecation-status.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes

WARNING: 'carefuly' may be misspelled - perhaps 'carefully'?
#40: FILE: include/linux/gfp.h:60:
+ * cannot handle allocation failures. New users should be evaluated carefuly

total: 0 errors, 1 warnings, 12 lines checked

./patches/mm-clarify-__gfp_nofail-deprecation-status.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/gfp.h~mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes include/linux/gfp.h
--- a/include/linux/gfp.h~mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes
+++ a/include/linux/gfp.h
@@ -57,7 +57,7 @@ struct vm_area_struct;
  * _might_ fail.  This depends upon the particular VM implementation.
  *
  * __GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
- * cannot handle allocation failures. New users should be evaluated carefuly
+ * cannot handle allocation failures. New users should be evaluated carefully
  * (and the flag should be used only when there is no reasonable failure policy)
  * but it is definitely preferable to use the flag rather than opencode endless
  * loop around allocator.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ocfs2-make-mlog_errno-return-the-errno.patch
mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473.patch
mm-cma-release-trigger.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition.patch
page_writeback-cleanup-mess-around-cancel_dirty_page.patch
mm-hide-per-cpu-lists-in-output-of-show_mem.patch
mm-clarify-__gfp_nofail-deprecation-status.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch

