From: akpm@linux-foundation.org
Subject: [merged] spi-fix-spi_write_then_read-comment.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:44:11 -0700
Message-ID: <200906182244.n5IMiBH4003280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758784AbZFRWo3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:44:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jpirko@redhat.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     spi: fix spi_write_then_read() comment
has been removed from the -mm tree.  Its filename was
     spi-fix-spi_write_then_read-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: fix spi_write_then_read() comment
From: Jiri Pirko <jpirko@redhat.com>

Buffer needs not be dma-safe, not rx data length.

Signed-off-by: Jiri Pirko <jpirko@redhat.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/spi/spi.c~spi-fix-spi_write_then_read-comment drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-fix-spi_write_then_read-comment
+++ a/drivers/spi/spi.c
@@ -700,8 +700,8 @@ static u8	*buf;
  * @spi: device with which data will be exchanged
  * @txbuf: data to be written (need not be dma-safe)
  * @n_tx: size of txbuf, in bytes
- * @rxbuf: buffer into which data will be read
- * @n_rx: size of rxbuf, in bytes (need not be dma-safe)
+ * @rxbuf: buffer into which data will be read (need not be dma-safe)
+ * @n_rx: size of rxbuf, in bytes
  * Context: can sleep
  *
  * This performs a half duplex MicroWire style transaction with the
_

Patches currently in -mm which might be from jpirko@redhat.com are

origin.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch

