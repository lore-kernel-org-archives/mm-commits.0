From: akpm@linux-foundation.org
Subject: [to-be-updated] blackfin-spi-driver-add-comment-about-full-duplex-dma-according-to-david-brownell.patch removed from -mm tree
Date: Mon, 09 Feb 2009 14:58:41 -0800
Message-ID: <200902092258.n19Mwf9M004125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235AbZBIW6w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 17:58:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     Blackfin SPI Driver: add comment about full duplex dma according to David Brownell
has been removed from the -mm tree.  Its filename was
     blackfin-spi-driver-add-comment-about-full-duplex-dma-according-to-david-brownell.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin SPI Driver: add comment about full duplex dma according to David Brownell
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-add-comment-about-full-duplex-dma-according-to-david-brownell drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-add-comment-about-full-duplex-dma-according-to-david-brownell
+++ a/drivers/spi/spi_bfin5xx.c
@@ -738,9 +738,10 @@ static void pump_transfers(unsigned long
 		width, transfer->len);
 
 	/*
-	 * Try to map dma buffer and do a dma transfer if
-	 * successful use different way to r/w according to
-	 * drv_data->cur_chip->enable_dma
+	 * Try to map dma buffer and do a dma transfer.  If successful use,
+	 * different way to r/w according to the enable_dma settings and if
+	 * we are not doing a full duplex transfer (since the hardware does
+	 * not support full duplex DMA transfers).
 	 */
 	if (!full_duplex && drv_data->cur_chip->enable_dma
 				&& drv_data->len > 6) {
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

video-framebuffer-move-the-probe-func-into-devinittext-in-blackfin-lcd-driver.patch
linux-next.patch
blackfin-nfc-driver-do-not-clobber-dmac1_perimux.patch
blackfin-nfc-driver-mark-bf5xx_nand_add_partition-as-__devinit.patch
blackfin-nfc-driver-drop-pointless-casts-with-set_dma_callback.patch
mtd-maps-blackfin-async-flash-maps-fix-bug-dont-leak-resources-when-initializing-in-case-of-errors.patch
mtd-maps-blackfin-async-flash-maps-bfin-async-mtd-driver-needs-complex-mappings.patch
mtd-maps-blackfin-async-flash-maps-fix-up-memory-leak.patch
blackfin-spi-driver-ensure-cache-coherency-before-doing-dma.patch
blackfin-spi-driver-remove-useless-asm-cplbinith.patch
blackfin-spi-driver-use-len_in_bytes-when-we-care-about-the-number-of-bytes-transferred.patch
blackfin-spi-driver-pass-dma-overflow-error-to-the-higher-level.patch
blackfin-spi-driver-unify-duplicated-code-in-dma-read-write-paths.patch
blackfin-spi-driver-drop-bogus-cast-and-touchup-dma-label.patch
blackfin-spi-driver-add-a-few-more-dma-debug-messages.patch
blackfin-spi-driver-do-not-check-for-spi-errors-if-dma-itself-did-not-flag-any.patch
blackfin-spi-driver-use-the-properl-bit_ctl_xxx-defines.patch
blackfin-spi-driver-spi-slave-select-code-cleanup.patch
blackfin-spi-driver-get-dma-working-for-spi-flashes.patch
blackfin-spi-driver-add-timeout-while-waiting-for-spif-in-dma-irq-handler.patch
blackfin-spi-driver-tweak-magic-spi-dma-sequence-to-get-it-working-on-bf54x.patch
blackfin-spi-driver-use-bfin_spi_-prefix-on-all-functions.patch
blackfin-spi-driver-fix-null-pointer-crash.patch
blackfin-spi-driver-add-comment-about-full-duplex-dma-according-to-david-brownell.patch
bin_elf_fdpic-check-the-return-value-of-clear_user.patch

