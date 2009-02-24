From: akpm@linux-foundation.org
Subject: + spi_bfin5xx-remove-unused-is_dma_aligned-macro.patch added to -mm tree
Date: Tue, 24 Feb 2009 12:40:30 -0800
Message-ID: <200902242040.n1OKeUqR009356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758189AbZBXUlE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 15:41:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike@compulab.co.il, bryan.wu@analog.com, david-b@pacbell.net


The patch titled
     spi_bfin5xx: remove unused IS_DMA_ALIGNED macro
has been added to the -mm tree.  Its filename is
     spi_bfin5xx-remove-unused-is_dma_aligned-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
