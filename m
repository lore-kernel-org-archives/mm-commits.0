From: akpm@linux-foundation.org
Subject: + mm-fix-a-spelling-mistake.patch added to -mm tree
Date: Tue, 04 Nov 2014 12:43:24 -0800
Message-ID: <54593a6c.4VfMmw2svm0QYFTi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47639 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbaKDUnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 15:43:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyuan.wei@huawei.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix a spelling mistake
has been added to the -mm tree.  Its filename is
     mm-fix-a-spelling-mistake.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-a-spelling-mistake.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-a-spelling-mistake.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yuan <weiyuan.wei@huawei.com>
Subject: mm: fix a spelling mistake

Signed-off-by Wei Yuan <weiyuan.wei@huawei.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-fix-a-spelling-mistake mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-a-spelling-mistake
+++ a/mm/page_alloc.c
@@ -1703,7 +1703,7 @@ static bool __zone_watermark_ok(struct z
 			unsigned long mark, int classzone_idx, int alloc_flags,
 			long free_pages)
 {
-	/* free_pages my go negative - that's OK */
+	/* free_pages may go negative - that's OK */
 	long min = mark;
 	int o;
 	long free_cma = 0;
_

Patches currently in -mm which might be from weiyuan.wei@huawei.com are

mm-fix-a-spelling-mistake.patch

