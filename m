From: akpm@linux-foundation.org
Subject: [merged] mm-page_allocc-fix-typos-in-comments.patch
 removed from -mm tree
Date: Thu, 01 Feb 2018 11:34:07 -0800
Message-ID: <20180201193407.OUQ9aq468%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60414 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754648AbeBATeK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:34:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangshile@gmail.com


The patch titled
     Subject: mm/page_alloc.c: fix typos in comments
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-fix-typos-in-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shile Zhang <zhangshile@gmail.com>
Subject: mm/page_alloc.c: fix typos in comments

Link: http://lkml.kernel.org/r/1515485774-4768-1-git-send-email-zhangshile@gmail.com
Signed-off-by: Shile Zhang <zhangshile@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-fix-typos-in-comments mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-fix-typos-in-comments
+++ a/mm/page_alloc.c
@@ -293,7 +293,7 @@ int page_group_by_mobility_disabled __re
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 
 /*
- * Determine how many pages need to be initialized durig early boot
+ * Determine how many pages need to be initialized during early boot
  * (non-deferred initialization).
  * The value of first_deferred_pfn will be set later, once non-deferred pages
  * are initialized, but for now set it ULONG_MAX.
@@ -344,7 +344,7 @@ static inline bool update_defer_init(pg_
 				unsigned long pfn, unsigned long zone_end,
 				unsigned long *nr_initialised)
 {
-	/* Always populate low zones for address-contrained allocations */
+	/* Always populate low zones for address-constrained allocations */
 	if (zone_end < pgdat_end_pfn(pgdat))
 		return true;
 	(*nr_initialised)++;
@@ -3397,7 +3397,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	if (gfp_mask & __GFP_THISNODE)
 		goto out;
 
-	/* Exhausted what can be done so it's blamo time */
+	/* Exhausted what can be done so it's blame time */
 	if (out_of_memory(&oc) || WARN_ON_ONCE(gfp_mask & __GFP_NOFAIL)) {
 		*did_some_progress = 1;
 
_

Patches currently in -mm which might be from zhangshile@gmail.com are


