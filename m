From: akpm@linux-foundation.org
Subject: [merged] mm-page_allocc-add-and-in-comment.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:11:10 -0700
Message-ID: <552eb7ce.RkcVBadxq82ycfwO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933580AbbDOTLK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:11:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: clean up comment
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-add-and-in-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: mm/page_alloc.c: clean up comment

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_allocc-add-and-in-comment mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-add-and-in-comment
+++ a/mm/page_alloc.c
@@ -5760,7 +5760,7 @@ static void __setup_per_zone_wmarks(void
 			 * value here.
 			 *
 			 * The WMARK_HIGH-WMARK_LOW and (WMARK_LOW-WMARK_MIN)
-			 * deltas controls asynch page reclaim, and so should
+			 * deltas control asynch page reclaim, and so should
 			 * not be capped for highmem.
 			 */
 			unsigned long min_pages;
_

Patches currently in -mm which might be from bywxiaobai@163.com are

origin.patch
mm-oom_killc-fix-a-typo.patch
linux-next.patch

