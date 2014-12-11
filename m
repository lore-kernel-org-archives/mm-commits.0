From: akpm@linux-foundation.org
Subject: [merged] mm-fix-a-spelling-mistake.patch removed from -mm tree
Date: Thu, 11 Dec 2014 10:57:40 -0800
Message-ID: <5489e924.PMIplxFQot1qUvE5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45418 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbaLKS5k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:57:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyuan.wei@huawei.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix a spelling mistake
has been removed from the -mm tree.  Its filename was
     mm-fix-a-spelling-mistake.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1739,7 +1739,7 @@ static bool __zone_watermark_ok(struct z
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

origin.patch

