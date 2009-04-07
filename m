From: akpm@linux-foundation.org
Subject: [merged] blackfin-spi-driver-spi-slave-select-code-cleanup.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:06:38 -0700
Message-ID: <200904071906.n37J6ccY010934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760767AbZDGTKe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:10:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     Blackfin SPI Driver: SPI slave select code cleanup
has been removed from the -mm tree.  Its filename was
     blackfin-spi-driver-spi-slave-select-code-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin SPI Driver: SPI slave select code cleanup
From: Mike Frysinger <vapier.adi@gmail.com>

- remove duplicated definition MAX_SPI_SSEL

- remove unnecessary array size

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-spi-slave-select-code-cleanup drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-spi-slave-select-code-cleanup
+++ a/drivers/spi/spi_bfin5xx.c
@@ -198,8 +198,6 @@ static void cs_deactive(struct driver_da
 		udelay(chip->cs_chg_udelay);
 }
 
-#define MAX_SPI_SSEL	7
