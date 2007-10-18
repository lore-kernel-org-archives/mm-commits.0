From: akpm@linux-foundation.org
Subject: - i-oat-add-completion-callback-for-async_tx-interface-use-fix-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 01:58:30 -0700
Message-ID: <200710180858.l9I8wUm6003241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60453 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933696AbXJRI7A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 04:59:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.j.williams@intel.com, shannon.nelson@intel.com, mm-commits@vger.kernel.org


The patch titled
     i-oat-add-completion-callback-for-async_tx-interface-use-fix-fix
has been removed from the -mm tree.  Its filename was
     i-oat-add-completion-callback-for-async_tx-interface-use-fix-fix.patch

This patch was dropped because it was folded into i-oat-add-completion-callback-for-async_tx-interface-use.patch

------------------------------------------------------
Subject: i-oat-add-completion-callback-for-async_tx-interface-use-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Shannon Nelson <shannon.nelson@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ioat_dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/dma/ioat_dma.c~i-oat-add-completion-callback-for-async_tx-interface-use-fix-fix drivers/dma/ioat_dma.c
--- a/drivers/dma/ioat_dma.c~i-oat-add-completion-callback-for-async_tx-interface-use-fix-fix
+++ a/drivers/dma/ioat_dma.c
@@ -657,7 +657,7 @@ static void ioat_dma_start_null_desc(str
 
 static void ioat_dma_test_callback(void *dma_async_param)
 {
-	printk(KERN_ERR "ioatdma: ioat_dma_test_callback(0x%p)\n",
+	printk(KERN_ERR "ioatdma: ioat_dma_test_callback(%p)\n",
 			dma_async_param);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
stop-using-dma_xxbit_mask.patch
fuse-fix-race-between-getattr-and-write.patch
fuse-add-file-handle-to-getattr-operation.patch
sparse-pointer-use-of-zero-as-null.patch
i-oat-tighten-descriptor-setup-performance.patch
i-oat-add-completion-callback-for-async_tx-interface-use.patch
i-oat-add-completion-callback-for-async_tx-interface-use-fix-fix.patch
