From: akpm@linux-foundation.org
Subject: - spi_imx-spelling-fixes.patch removed from -mm tree
Date: Mon, 04 Feb 2008 18:54:16 -0800
Message-ID: <200802050253.m152rvs5031546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59384 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753002AbYBECyj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 21:54:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi_imx spelling fixes
has been removed from the -mm tree.  Its filename was
     spi_imx-spelling-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_imx spelling fixes
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_imx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/spi_imx.c~spi_imx-spelling-fixes drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi_imx-spelling-fixes
+++ a/drivers/spi/spi_imx.c
@@ -157,7 +157,7 @@
 #define SPI_FIFO_BYTE_WIDTH		(2)
 #define SPI_FIFO_OVERFLOW_MARGIN	(2)
 
-/* DMA burst lenght for half full/empty request trigger */
+/* DMA burst length for half full/empty request trigger */
 #define SPI_DMA_BLR			(SPI_FIFO_DEPTH * SPI_FIFO_BYTE_WIDTH / 2)
 
 /* Dummy char output to achieve reads.
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
uml-add-missing-space.patch
uml-style-fixes-in-arch-um-kernel.patch
git-cpufreq.patch
git-hwmon.patch
git-kvm.patch
git-unionfs.patch
printk_ratelimit-functions-should-use-config_printk.patch
