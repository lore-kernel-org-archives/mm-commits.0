From: akpm@linux-foundation.org
Subject: [merged] replace-all-dma_48bit_mask-macro-with-dma_bit_mask48.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:07:51 -0700
Message-ID: <200904071907.n37J7phB011515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754535AbZDGTJM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:09:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yanghy@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     dma-mapping: replace all DMA_48BIT_MASK macro with DMA_BIT_MASK(48)
has been removed from the -mm tree.  Its filename was
     replace-all-dma_48bit_mask-macro-with-dma_bit_mask48.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: replace all DMA_48BIT_MASK macro with DMA_BIT_MASK(48)
From: Yang Hongyang <yanghy@cn.fujitsu.com>

Replace all DMA_48BIT_MASK macro with DMA_BIT_MASK(48)

Signed-off-by: Yang Hongyang<yanghy@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/dl2k.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/dl2k.c~replace-all-dma_48bit_mask-macro-with-dma_bit_mask48 drivers/net/dl2k.c
--- a/drivers/net/dl2k.c~replace-all-dma_48bit_mask-macro-with-dma_bit_mask48
+++ a/drivers/net/dl2k.c
@@ -714,7 +714,7 @@ rio_interrupt (int irq, void *dev_instan
 
 static inline dma_addr_t desc_to_dma(struct netdev_desc *desc)
 {
-	return le64_to_cpu(desc->fraginfo) & DMA_48BIT_MASK;
+	return le64_to_cpu(desc->fraginfo) & DMA_BIT_MASK(48);
 }
 
 static void
_

Patches currently in -mm which might be from yanghy@cn.fujitsu.com are

origin.patch

