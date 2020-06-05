From: akpm@linux-foundation.org
Subject: [merged] mm-vmsan-fix-some-typos-in-comment.patch removed
 from -mm tree
Date: Fri, 05 Jun 2020 13:18:24 -0700
Message-ID: <20200605201824.eBwjpcrM4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728041AbgFEUSZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:18:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ethp@qq.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com


The patch titled
     Subject: mm/vmsan: fix some typos in comment
has been removed from the -mm tree.  Its filename was
     mm-vmsan-fix-some-typos-in-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ethon Paul <ethp@qq.com>
Subject: mm/vmsan: fix some typos in comment

There are some typos, fix them.

s/regsitration/registration
s/santity/sanity
s/decremeting/decrementing

Link: http://lkml.kernel.org/r/20200411071544.16222-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-vmsan-fix-some-typos-in-comment
+++ a/mm/vmscan.c
@@ -682,7 +682,7 @@ static unsigned long shrink_slab(gfp_t g
 		freed += ret;
 		/*
 		 * Bail out if someone want to register a new shrinker to
-		 * prevent the regsitration from being stalled for long periods
+		 * prevent the registration from being stalled for long periods
 		 * by parallel ongoing shrinking.
 		 */
 		if (rwsem_is_contended(&shrinker_rwsem)) {
@@ -1613,7 +1613,7 @@ int __isolate_lru_page(struct page *page
 
 /*
  * Update LRU sizes after isolating pages. The LRU size updates must
- * be complete before mem_cgroup_update_lru_size due to a santity check.
+ * be complete before mem_cgroup_update_lru_size due to a sanity check.
  */
 static __always_inline void update_lru_sizes(struct lruvec *lruvec,
 			enum lru_list lru, unsigned long *nr_zone_taken)
@@ -2371,7 +2371,7 @@ out:
 
 			/*
 			 * Minimally target SWAP_CLUSTER_MAX pages to keep
-			 * reclaim moving forwards, avoiding decremeting
+			 * reclaim moving forwards, avoiding decrementing
 			 * sc->priority further than desirable.
 			 */
 			scan = max(scan, SWAP_CLUSTER_MAX);
_

Patches currently in -mm which might be from ethp@qq.com are
