From: akpm@linux-foundation.org
Subject: - pxa2xx_spi-fix-typo-in-description.patch removed from -mm tree
Date: Tue, 11 Dec 2007 14:41:47 -0800
Message-ID: <200712112241.lBBMflfE012558@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47114 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754736AbXLKWmW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 17:42:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.newton@gmail.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     pxa2xx_spi: fix typo in description
has been removed from the -mm tree.  Its filename was
     pxa2xx_spi-fix-typo-in-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pxa2xx_spi: fix typo in description
From: "Will Newton" <will.newton@gmail.com>

Signed-off-by: Will Newton <will.newton@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/pxa2xx_spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/pxa2xx_spi.c~pxa2xx_spi-fix-typo-in-description drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~pxa2xx_spi-fix-typo-in-description
+++ a/drivers/spi/pxa2xx_spi.c
@@ -39,7 +39,7 @@
 #include <asm/arch/pxa2xx_spi.h>
 
 MODULE_AUTHOR("Stephen Street");
-MODULE_DESCRIPTION("PXA2xx SSP SPI Contoller");
+MODULE_DESCRIPTION("PXA2xx SSP SPI Controller");
 MODULE_LICENSE("GPL");
 
 #define MAX_BUSES 3
_

Patches currently in -mm which might be from will.newton@gmail.com are
