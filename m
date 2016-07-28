From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 28 Jul 2016 14:49:57 -0700
Message-ID: <579a7e05.CTz48rIm/enbQHWA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54373 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbcG1Vt6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 17:49:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-update-the-comment-in-__isolate_free_page.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes

WARNING: line over 80 characters
#29: FILE: mm/page_alloc.c:2517:
+	/* Set the pageblock if the isolated page is at least half of a pageblock */

total: 0 errors, 1 warnings, 8 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-update-the-comment-in-__isolate_free_page.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: zhong jiang <zhongjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -2517,7 +2517,10 @@ int __isolate_free_page(struct page *pag
 	zone->free_area[order].nr_free--;
 	rmv_page_order(page);
 
-	/* Set the pageblock if the isolated page is at least half of a pageblock */
+	/*
+	 * Set the pageblock if the isolated page is at least half of a
+	 * pageblock
+	 */
 	if (order >= pageblock_order - 1) {
 		struct page *endpage = page + (1 << order) - 1;
 		for (; page < endpage; page += pageblock_nr_pages) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-update-the-comment-in-__isolate_free_page.patch
mm-bail-out-in-shrin_inactive_list-fix.patch
revert-mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements-checkpatch-fixes.patch
mm-optimize-copy_page_to-from_iter_iovec-fix.patch
mm-optimize-copy_page_to-from_iter_iovec-fix-fix.patch

