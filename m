From: akpm@linux-foundation.org
Subject: + mm-page_allocc-fix-typos-in-comments.patch added to -mm tree
Date: Tue, 09 Jan 2018 15:39:29 -0800
Message-ID: <5a5552b1.+xpQ/w0UW7EsXE22%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32918 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751926AbeAIXja (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jan 2018 18:39:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhangshile@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: fix typos in comments
has been added to the -mm tree.  Its filename is
     mm-page_allocc-fix-typos-in-comments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-fix-typos-in-comments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-fix-typos-in-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -294,7 +294,7 @@ int page_group_by_mobility_disabled __re
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 
 /*
- * Determine how many pages need to be initialized durig early boot
+ * Determine how many pages need to be initialized during early boot
  * (non-deferred initialization).
  * The value of first_deferred_pfn will be set later, once non-deferred pages
  * are initialized, but for now set it ULONG_MAX.
@@ -345,7 +345,7 @@ static inline bool update_defer_init(pg_
 				unsigned long pfn, unsigned long zone_end,
 				unsigned long *nr_initialised)
 {
-	/* Always populate low zones for address-contrained allocations */
+	/* Always populate low zones for address-constrained allocations */
 	if (zone_end < pgdat_end_pfn(pgdat))
 		return true;
 	(*nr_initialised)++;
@@ -3405,7 +3405,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	if (gfp_mask & __GFP_THISNODE)
 		goto out;
 
-	/* Exhausted what can be done so it's blamo time */
+	/* Exhausted what can be done so it's blame time */
 	if (out_of_memory(&oc) || WARN_ON_ONCE(gfp_mask & __GFP_NOFAIL)) {
 		*did_some_progress = 1;
 
_

Patches currently in -mm which might be from zhangshile@gmail.com are

mm-page_allocc-fix-typos-in-comments.patch

