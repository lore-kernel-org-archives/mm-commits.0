From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-hugetlb-add-description-for-alloc_gigantic_page.patch removed from -mm
 tree
Date: Fri, 02 Dec 2016 16:37:31 -0800
Message-ID: <584213cb.MJebiaCovwxnhZ53%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33338 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758179AbcLCAhK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2016 19:37:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie.huang@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: add description for alloc_gigantic_page()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-description-for-alloc_gigantic_page.patch

This patch was dropped because an updated version will be merged

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


