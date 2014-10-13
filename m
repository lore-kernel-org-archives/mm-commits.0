From: akpm@linux-foundation.org
Subject: [folded-merged]
 drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 13 Oct 2014 14:08:09 -0700
Message-ID: <543c3f39.OsTz4uDDtojfjm4G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33248 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaJMVIK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 17:08:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, grant.likely@linaro.org, iamjoonsoo.kim@lge.com, joshc@codeaurora.org, kyungmin.park@samsung.com, lauraa@codeaurora.org, m.szyprowski@samsung.com, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch

This patch was dropped because it was folded into drivers-dma-coherent-add-initialization-from-device-tree.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes

WARNING: line over 80 characters
#130: FILE: drivers/base/dma-coherent.c:20:
+static int dma_init_coherent_memory(phys_addr_t phys_addr, dma_addr_t device_addr,

WARNING: Missing a blank line after declarations
#320: FILE: drivers/base/dma-coherent.c:283:
+	struct dma_coherent_mem *mem = rmem->priv;
+	if (!mem &&

total: 0 errors, 2 warnings, 233 lines checked

./patches/drivers-dma-coherent-add-initialization-from-device-tree.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Josh Cartwright <joshc@codeaurora.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dma-coherent.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/base/dma-coherent.c~drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes drivers/base/dma-coherent.c
--- a/drivers/base/dma-coherent.c~drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes
+++ a/drivers/base/dma-coherent.c
@@ -279,6 +279,7 @@ EXPORT_SYMBOL(dma_mmap_from_coherent);
 static int rmem_dma_device_init(struct reserved_mem *rmem, struct device *dev)
 {
 	struct dma_coherent_mem *mem = rmem->priv;
+
 	if (!mem &&
 	    dma_init_coherent_memory(rmem->base, rmem->base, rmem->size,
 				     DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cma-fix-cma-bitmap-aligned-mask-computing-checkpatch-fixes.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
drivers-dma-contiguous-add-initialization-from-device-tree-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch

