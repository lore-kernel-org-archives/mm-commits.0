From: akpm@linux-foundation.org
Subject: + pxa2xx_spi-fix-typo-in-description.patch added to -mm tree
Date: Thu, 06 Dec 2007 11:41:51 -0800
Message-ID: <200712061941.lB6Jfpi8008474@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55896 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752882AbXLFTmN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Dec 2007 14:42:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will.newton@gmail.com, dbrownell@users.sourceforge.net


The patch titled
     pxa2xx_spi: fix typo in description
has been added to the -mm tree.  Its filename is
     pxa2xx_spi-fix-typo-in-description.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

pxa2xx_spi-fix-typo-in-description.patch
spi_bfin5xx-fix-typo-in-description.patch
spi_imx-fix-typo-in-description.patch
