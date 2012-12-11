From: akpm@linux-foundation.org
Subject: [folded-merged] mm-cma-remove-watermark-hacks-fix.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:53:50 -0800
Message-ID: <20121211235350.7F7B6100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:54952 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab2LKXxv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:53:51 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so8316vcd.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:53:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.szyprowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: remove watermark hacks (fix)
has been removed from the -mm tree.  Its filename was
     mm-cma-remove-watermark-hacks-fix.patch

This patch was dropped because it was folded into mm-cma-remove-watermark-hacks.patch

------------------------------------------------------
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: mm: cma: remove watermark hacks (fix)

mm/page_alloc.c: In function `alloc_contig_range':
mm/page_alloc.c:5825:15: warning: unused variable `zone' [-Wunused-variable]

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/page_alloc.c~mm-cma-remove-watermark-hacks-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cma-remove-watermark-hacks-fix
+++ a/mm/page_alloc.c
@@ -5838,7 +5838,6 @@ static int __alloc_contig_migrate_range(
 int alloc_contig_range(unsigned long start, unsigned long end,
 		       unsigned migratetype)
 {
-	struct zone *zone = page_zone(pfn_to_page(start));
 	unsigned long outer_start, outer_end;
 	int ret = 0, order;
 
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

origin.patch
mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page.patch
mm-cma-remove-watermark-hacks.patch

