From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmsan-fix-some-typos-in-comment.patch added to -mm
 tree
Date: Mon, 13 Apr 2020 15:36:13 -0700
Message-ID: <20200413223613.Z_d8ELrNQ%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389688AbgDMWnR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 18:43:17 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ethp@qq.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmsan: fix some typos in comment
has been added to the -mm tree.  Its filename is
     mm-vmsan-fix-some-typos-in-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmsan-fix-some-typos-in-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmsan-fix-some-typos-in-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-vmsan-fix-some-typos-in-comment
+++ a/mm/vmscan.c
@@ -676,7 +676,7 @@ static unsigned long shrink_slab(gfp_t g
 		freed += ret;
 		/*
 		 * Bail out if someone want to register a new shrinker to
-		 * prevent the regsitration from being stalled for long periods
+		 * prevent the registration from being stalled for long periods
 		 * by parallel ongoing shrinking.
 		 */
 		if (rwsem_is_contended(&shrinker_rwsem)) {
@@ -1591,7 +1591,7 @@ int __isolate_lru_page(struct page *page
 
 /*
  * Update LRU sizes after isolating pages. The LRU size updates must
- * be complete before mem_cgroup_update_lru_size due to a santity check.
+ * be complete before mem_cgroup_update_lru_size due to a sanity check.
  */
 static __always_inline void update_lru_sizes(struct lruvec *lruvec,
 			enum lru_list lru, unsigned long *nr_zone_taken)
@@ -2389,7 +2389,7 @@ out:
 
 			/*
 			 * Minimally target SWAP_CLUSTER_MAX pages to keep
-			 * reclaim moving forwards, avoiding decremeting
+			 * reclaim moving forwards, avoiding decrementing
 			 * sc->priority further than desirable.
 			 */
 			scan = max(scan, SWAP_CLUSTER_MAX);
_

Patches currently in -mm which might be from ethp@qq.com are

mm-memory_hotplug-fix-a-typo-in-comment-recoreded-recorded.patch
mm-ksm-fix-a-typo-in-comment-alreaady-already.patch
mm-mmap-fix-a-typo-in-comment-compatbility-compatibility.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained.patch
mm-vmsan-fix-some-typos-in-comment.patch
