From: akpm@linux-foundation.org
Subject: [merged] spi_bfin5xx-remove-unused-is_dma_aligned-macro.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:07:07 -0700
Message-ID: <200904071907.n37J779g011158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760395AbZDGTKi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:10:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike@compulab.co.il, bryan.wu@analog.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     spi_bfin5xx: remove unused IS_DMA_ALIGNED macro
has been removed from the -mm tree.  Its filename was
     spi_bfin5xx-remove-unused-is_dma_aligned-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_bfin5xx: remove unused IS_DMA_ALIGNED macro
From: Mike Rapoport <mike@compulab.co.il>

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi_bfin5xx-remove-unused-is_dma_aligned-macro drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi_bfin5xx-remove-unused-is_dma_aligned-macro
+++ a/drivers/spi/spi_bfin5xx.c
@@ -36,8 +36,6 @@ MODULE_AUTHOR(DRV_AUTHOR);
 MODULE_DESCRIPTION(DRV_DESC);
 MODULE_LICENSE("GPL");
 
-#define IS_DMA_ALIGNED(x) (((u32)(x)&0x07) == 0)
