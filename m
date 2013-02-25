From: akpm@linux-foundation.org
Subject: [merged] mm-numa-fix-minor-typo-in-numa_next_scan.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:52:33 -0800
Message-ID: <20130225205233.DFA2D31C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:43331 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759745Ab3BYUwf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:52:35 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so347366ghb.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:52:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, a.p.zijlstra@chello.nl, aarcange@redhat.com, hughd@google.com, liwanp@linux.vnet.ibm.com, mingo@kernel.org, simon.jeons@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: numa: fix minor typo in numa_next_scan
has been removed from the -mm tree.  Its filename was
     mm-numa-fix-minor-typo-in-numa_next_scan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: numa: fix minor typo in numa_next_scan

s/me/be/ and clarify the comment a bit when we're changing it anyway.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Suggested-by: Simon Jeons <simon.jeons@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/mm_types.h~mm-numa-fix-minor-typo-in-numa_next_scan include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-numa-fix-minor-typo-in-numa_next_scan
+++ a/include/linux/mm_types.h
@@ -414,9 +414,9 @@ struct mm_struct {
 #endif
 #ifdef CONFIG_NUMA_BALANCING
 	/*
-	 * numa_next_scan is the next time when the PTEs will me marked
-	 * pte_numa to gather statistics and migrate pages to new nodes
-	 * if necessary
+	 * numa_next_scan is the next time that the PTEs will be marked
+	 * pte_numa. NUMA hinting faults will gather statistics and migrate
+	 * pages to new nodes if necessary.
 	 */
 	unsigned long numa_next_scan;
 
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-memmap_init_zone-performance-improvement.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch

