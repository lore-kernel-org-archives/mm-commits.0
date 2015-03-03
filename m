From: akpm@linux-foundation.org
Subject: + mm-page_allocc-add-and-in-comment.patch added to -mm tree
Date: Mon, 02 Mar 2015 16:36:07 -0800
Message-ID: <54f501f7.+MKasl916AhV1Qg+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbbCCAgI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 19:36:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: clean up comment
has been added to the -mm tree.  Its filename is
     mm-page_allocc-add-and-in-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-add-and-in-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-add-and-in-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_allocc-add-and-in-comment.patch

