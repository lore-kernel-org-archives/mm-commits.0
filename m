From: akpm@linux-foundation.org
Subject: + mm-page_alloc-add-a-necessary-leave.patch added to -mm tree
Date: Tue, 10 Feb 2015 12:11:35 -0800
Message-ID: <54da65f7.zazWJiHL7Cb+1jaE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48969 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbbBJULg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Feb 2015 15:11:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: fix comment
has been added to the -mm tree.  Its filename is
     mm-page_alloc-add-a-necessary-leave.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-add-a-necessary-leave.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-add-a-necessary-leave.patch

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

mm-page_alloc-add-a-necessary-leave.patch
linux-next.patch

