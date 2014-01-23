From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null-fix.patch removed from -mm tree
Date: Thu, 23 Jan 2014 15:23:28 -0800
Message-ID: <52e1a470.CpAzO/TQhuHb7THb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaAWXX3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 18:23:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sachin.kamat@linaro.org, prabhakar.csengg@gmail.com, p.zabel@pengutronix.de, joe@perches.com, b42378@freescale.com, akpm@linux-foundation.org

Subject: [folded-merged] lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,b42378@freescale.com,joe@perches.com,p.zabel@pengutronix.de,prabhakar.csengg@gmail.com,sachin.kamat@linaro.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 15:23:28 -0800


The patch titled
     Subject: lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null-fix
has been removed from the -mm tree.  Its filename was
     lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null-fix.patch

This patch was dropped because it was folded into lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null-fix

Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Nicolin Chen <b42378@freescale.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/genalloc.c~lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null-fix lib/genalloc.c
--- a/lib/genalloc.c~lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null-fix
+++ a/lib/genalloc.c
@@ -316,7 +316,7 @@ EXPORT_SYMBOL(gen_pool_alloc);
  * gen_pool_dma_alloc - allocate special memory from the pool for DMA usage
  * @pool: pool to allocate from
  * @size: number of bytes to allocate from the pool
- * @dma: dma-view physical address
+ * @dma: dma-view physical address return value.  Use NULL if unneeded.
  *
  * Allocate the requested number of bytes from the specified pool.
  * Uses the pool allocation function (with first-fit algorithm by default).
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
printk-flush-conflicting-continuation-line.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch

