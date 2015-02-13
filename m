From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-add-a-necessary-leave.patch removed from
 -mm tree
Date: Fri, 13 Feb 2015 12:21:05 -0800
Message-ID: <54de5cb1.gwjC5xLp3Elc30k7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbbBMUVG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:21:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: fix comment
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-a-necessary-leave.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: mm/page_alloc: fix comment

Add a necessary 'leave'.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-add-a-necessary-leave mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-add-a-necessary-leave
+++ a/mm/page_alloc.c
@@ -172,7 +172,7 @@ static void __free_pages_ok(struct page
  *	1G machine -> (16M dma, 784M normal, 224M high)
  *	NORMAL allocation will leave 784M/256 of ram reserved in the ZONE_DMA
  *	HIGHMEM allocation will leave 224M/32 of ram reserved in ZONE_NORMAL
- *	HIGHMEM allocation will (224M+784M)/256 of ram reserved in ZONE_DMA
+ *	HIGHMEM allocation will leave (224M+784M)/256 of ram reserved in ZONE_DMA
  *
  * TBD: should special case ZONE_DMA32 machines here - in those we normally
  * don't need any ZONE_NORMAL reservation
_

Patches currently in -mm which might be from bywxiaobai@163.com are

origin.patch

