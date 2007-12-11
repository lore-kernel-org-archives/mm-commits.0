From: akpm@linux-foundation.org
Subject: - spi_bfin5xx-fix-typo-in-description.patch removed from -mm tree
Date: Tue, 11 Dec 2007 14:41:49 -0800
Message-ID: <200712112241.lBBMfnrs012561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59104 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755816AbXLKWma (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 17:42:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.newton@gmail.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi_bfin5xx: fix typo in description
has been removed from the -mm tree.  Its filename was
     spi_bfin5xx-fix-typo-in-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi_bfin5xx: fix typo in description
From: "Will Newton" <will.newton@gmail.com>

Signed-off-by: Will Newton <will.newton@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi_bfin5xx-fix-typo-in-description drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi_bfin5xx-fix-typo-in-description
+++ a/drivers/spi/spi_bfin5xx.c
@@ -54,7 +54,7 @@
 
 #define DRV_NAME	"bfin-spi"
 #define DRV_AUTHOR	"Bryan Wu, Luke Yang"
-#define DRV_DESC	"Blackfin BF5xx on-chip SPI Contoller Driver"
+#define DRV_DESC	"Blackfin BF5xx on-chip SPI Controller Driver"
 #define DRV_VERSION	"1.0"
 
 MODULE_AUTHOR(DRV_AUTHOR);
_

Patches currently in -mm which might be from will.newton@gmail.com are
