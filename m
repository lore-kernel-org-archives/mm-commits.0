From: akpm@linux-foundation.org
Subject: + mm-hugetlb-add-description-for-alloc_gigantic_page.patch added
 to -mm tree
Date: Wed, 30 Nov 2016 13:34:35 -0800
Message-ID: <583f45eb.HowpNnBe+kuDjA9A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52354 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758678AbcK3VeT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2016 16:34:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie.huang@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: add description for alloc_gigantic_page()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-add-description-for-alloc_gigantic_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-add-description-for-alloc_gigantic_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-add-description-for-alloc_gigantic_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Shijie <shijie.huang@arm.com>
Subject: mm: hugetlb: add description for alloc_gigantic_page()

This patch adds the description for function alloc_gigantic_page().

Link: http://lkml.kernel.org/r/1480487431-26181-1-git-send-email-shijie.huang@arm.com
Signed-off-by: Huang Shijie <shijie.huang@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/hugetlb.c~mm-hugetlb-add-description-for-alloc_gigantic_page mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-add-description-for-alloc_gigantic_page
+++ a/mm/hugetlb.c
@@ -1089,6 +1089,12 @@ static bool zone_spans_last_pfn(const st
 	return zone_spans_pfn(zone, last_pfn);
 }
 
+/*
+ * Allocate a gigantic page from @nid node.
+ *
+ * Scan the zones of @nid node, and try to allocate a number of contiguous
+ * pages (1 << order).
+ */
 static struct page *alloc_gigantic_page(int nid, unsigned int order)
 {
 	unsigned long nr_pages = 1 << order;
_

Patches currently in -mm which might be from shijie.huang@arm.com are

mm-hugetlb-rename-some-allocation-functions.patch
mm-hugetlb-add-a-new-parameter-for-some-functions.patch
mm-hugetlb-change-the-return-type-for-alloc_fresh_gigantic_page.patch
mm-mempolicy-intruduce-a-helper-huge_nodemask.patch
mm-mempolicy-intruduce-a-helper-huge_nodemask-v2.patch
mm-hugetlb-add-a-new-function-to-allocate-a-new-gigantic-page.patch
mm-hugetlb-add-a-new-function-to-allocate-a-new-gigantic-page-v2.patch
mm-hugetlb-support-gigantic-surplus-pages.patch
mm-hugetlb-add-description-for-alloc_gigantic_page.patch

