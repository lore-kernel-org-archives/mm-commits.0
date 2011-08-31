From: akpm@linux-foundation.org
Subject: + mm-page-writebackc-document-bdi_min_ratio.patch added to -mm tree
Date: Wed, 31 Aug 2011 15:59:22 -0700
Message-ID: <201108312259.p7VMxMHU032604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757119Ab1HaXAM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Aug 2011 19:00:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jweiner@redhat.com, fengguang.wu@intel.com, peterz@infradead.org


The patch titled
     mm/page-writeback.c: document bdi_min_ratio
has been added to the -mm tree.  Its filename is
     mm-page-writebackc-document-bdi_min_ratio.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/page-writeback.c: document bdi_min_ratio
From: Johannes Weiner <jweiner@redhat.com>

Looks like someone got distracted after adding the comment characters.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/page-writeback.c~mm-page-writebackc-document-bdi_min_ratio mm/page-writeback.c
--- a/mm/page-writeback.c~mm-page-writebackc-document-bdi_min_ratio
+++ a/mm/page-writeback.c
@@ -364,7 +364,9 @@ static unsigned long task_min_dirty_limi
 }
 
 /*
- *
+ * bdi_min_ratio keeps the sum of the minimum dirty shares of all
+ * registered backing devices, which, for obvious reasons, can not
+ * exceed 100%.
  */
 static unsigned int bdi_min_ratio;
 
_

Patches currently in -mm which might be from jweiner@redhat.com are

mm-change-isolate-mode-from-define-to-bitwise-type-fix.patch
mm-page-writebackc-document-bdi_min_ratio.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap-fix.patch
mm-vmscan-drop-nr_force_scan-from-get_scan_count.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch
xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch
ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch
mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch
mremap-check-for-overflow-using-deltas.patch
mremap-avoid-sending-one-ipi-per-page.patch
thp-mremap-support-and-tlb-optimization.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-compaction-compact-unevictable-pages.patch
mm-compaction-accounting-fix.patch
memcg-remove-unneeded-preempt_disable.patch

