From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-remove-page_queue_congested-comment.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:42:18 -0700
Message-ID: <200909222042.n8MKgIFF009308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753092AbZIVUnY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:43:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macli@brc.ubc.ca, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm/vmscan: remove page_queue_congested() comment
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-page_queue_congested-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/vmscan: remove page_queue_congested() comment
From: Vincent Li <macli@brc.ubc.ca>

Commit 084f71ae5c(kill page_queue_congested()) removed
page_queue_congested().  Remove the page_queue_congested() comment in
vmscan pageout() too.

Signed-off-by: Vincent Li <macli@brc.ubc.ca>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-remove-page_queue_congested-comment mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-remove-page_queue_congested-comment
+++ a/mm/vmscan.c
@@ -366,7 +366,6 @@ static pageout_t pageout(struct page *pa
 	 * block, for some throttling. This happens by accident, because
 	 * swap_backing_dev_info is bust: it doesn't reflect the
 	 * congestion state of the swapdevs.  Easy to fix, if needed.
-	 * See swapfile.c:page_queue_congested().
 	 */
 	if (!is_page_cache_freeable(page))
 		return PAGE_KEEP;
_

Patches currently in -mm which might be from macli@brc.ubc.ca are

origin.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check.patch
fs-proc-basec-fix-proc_fault_inject_write-input-sanity-check.patch

