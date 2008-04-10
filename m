From: akpm@linux-foundation.org
Subject: - spi-spi_bfin5xx-remove-unused-label.patch removed from -mm tree
Date: Thu, 10 Apr 2008 13:01:04 -0700
Message-ID: <200804102001.m3AK14Is014948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759272AbYDJUMh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 16:12:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.hennerich@analog.com, cooloney@kernel.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: spi_bfin5xx: remove unused label
has been removed from the -mm tree.  Its filename was
     spi-spi_bfin5xx-remove-unused-label.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: spi_bfin5xx: remove unused label
From: Michael Hennerich <michael.hennerich@analog.com>

Remove unused label, and associated compiler warning.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi-spi_bfin5xx-remove-unused-label drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi-spi_bfin5xx-remove-unused-label
+++ a/drivers/spi/spi_bfin5xx.c
@@ -1319,7 +1319,6 @@ out_error_no_dma_ch:
 	iounmap((void *) drv_data->regs_base);
 out_error_ioremap:
 out_error_get_res:
-out_error:
 	spi_master_put(master);
 
 	return status;
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

origin.patch
input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch

