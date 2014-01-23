From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-improve-documentation-of-page_order-v2-fix.patch removed from -mm tree
Date: Thu, 23 Jan 2014 15:21:17 -0800
Message-ID: <52e1a3ed.BBpzQl75VG5vOz4s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37215 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbaAWXVS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 18:21:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, akpm@linux-foundation.org

Subject: [folded-merged] mm-improve-documentation-of-page_order-v2-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,mgorman@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 15:21:17 -0800


The patch titled
     Subject: mm-improve-documentation-of-page_order-v2-fix
has been removed from the -mm tree.  Its filename was
     mm-improve-documentation-of-page_order-v2-fix.patch

This patch was dropped because it was folded into mm-improve-documentation-of-page_order-v2.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-improve-documentation-of-page_order-v2-fix

tweaks

Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/internal.h~mm-improve-documentation-of-page_order-v2-fix mm/internal.h
--- a/mm/internal.h~mm-improve-documentation-of-page_order-v2-fix
+++ a/mm/internal.h
@@ -143,10 +143,10 @@ isolate_migratepages_range(struct zone *
 #endif
 
 /*
- * This functions returns the order of a free page in the buddy system. In
+ * This function returns the order of a free page in the buddy system. In
  * general, page_zone(page)->lock must be held by the caller to prevent the
- * page being allocated in parallel and returning garbage as the order. If the
- * caller does not hold page_zone(page)->lock, they must guarantee that the
+ * page from being allocated in parallel and returning garbage as the order.
+ * If a caller does not hold page_zone(page)->lock, it must guarantee that the
  * page cannot be allocated or merged in parallel.
  */
 static inline unsigned long page_order(struct page *page)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-print-more-details-for-bad_page.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch
numa-add-a-sysctl-for-numa_balancing.patch
mm-nobootmem-free_all_bootmem-again.patch
mm-improve-documentation-of-page_order-v2.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
printk-flush-conflicting-continuation-line-fix.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null-fix.patch
drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch

