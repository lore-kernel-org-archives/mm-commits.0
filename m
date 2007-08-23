From: akpm@linux-foundation.org
Subject: + fix-typo-in-atmel_spic.patch added to -mm tree
Date: Thu, 23 Aug 2007 15:14:11 -0700
Message-ID: <200708232214.l7NMEBQH029401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39183 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757767AbXHWWRI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 18:17:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andrew@sanpeople.com, david-b@pacbell.net, hskinnemoen@atmel.com


The patch titled
     Fix typo in atmel_spi.c
has been added to the -mm tree.  Its filename is
     fix-typo-in-atmel_spic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix typo in atmel_spi.c
From: Andrew Victor <andrew@sanpeople.com>

Fix cut 'n paste bug in Atmel SPI driver.

Signed-off-by: Andrew Victor <andrew@sanpeople.com>
Acked-by: David Brownell <david-b@pacbell.net>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/atmel_spi.c~fix-typo-in-atmel_spic drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~fix-typo-in-atmel_spic
+++ a/drivers/spi/atmel_spi.c
@@ -251,7 +251,7 @@ atmel_spi_dma_map_xfer(struct atmel_spi 
 		xfer->rx_dma = dma_map_single(dev,
 				xfer->rx_buf, xfer->len,
 				DMA_FROM_DEVICE);
-		if (dma_mapping_error(xfer->tx_dma)) {
+		if (dma_mapping_error(xfer->rx_dma)) {
 			if (xfer->tx_buf)
 				dma_unmap_single(dev,
 						xfer->tx_dma, xfer->len,
_

Patches currently in -mm which might be from andrew@sanpeople.com are

origin.patch
fix-typo-in-atmel_spic.patch
at91-remove-at91_lcdch.patch
git-mtd.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
