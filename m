From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-rename-and-move-get-set_freepage_migratetype-v2.patch removed from -mm
 tree
Date: Tue, 08 Sep 2015 14:42:41 -0700
Message-ID: <55ef5651.sTcx1P7tVOv5VyWy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53150 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbbIHVmm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 17:42:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rename-and-move-get-set_freepage_migratetype-v2
has been removed from the -mm tree.  Its filename was
     mm-rename-and-move-get-set_freepage_migratetype-v2.patch

This patch was dropped because it was folded into mm-rename-and-move-get-set_freepage_migratetype.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-rename-and-move-get-set_freepage_migratetype-v2

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/page_alloc.c~mm-rename-and-move-get-set_freepage_migratetype-v2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-rename-and-move-get-set_freepage_migratetype-v2
+++ a/mm/page_alloc.c
@@ -974,7 +974,6 @@ static void __free_pages_ok(struct page
 	migratetype = get_pfnblock_migratetype(page, pfn);
 	local_irq_save(flags);
 	__count_vm_events(PGFREE, 1 << order);
-	set_pcppage_migratetype(page, migratetype);
 	free_one_page(page_zone(page), page, pfn, order, migratetype);
 	local_irq_restore(flags);
 }
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch
mm-rename-and-move-get-set_freepage_migratetype.patch
mm-compaction-more-robust-check-for-scanners-meeting.patch
mm-compaction-simplify-handling-restart-position-in-free-pages-scanner.patch
mm-compaction-encapsulate-resetting-cached-scanner-positions.patch
mm-compaction-always-skip-compound-pages-by-order-in-migrate-scanner.patch
mm-compaction-skip-compound-pages-by-order-in-free-scanner.patch
mm-rename-alloc_pages_exact_node-to-__alloc_pages_node.patch
mm-unify-checks-in-alloc_pages_node-and-__alloc_pages_node.patch
mm-use-numa_mem_id-in-alloc_pages_node.patch

