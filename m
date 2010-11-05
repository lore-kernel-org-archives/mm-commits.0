From: akpm@linux-foundation.org
Subject: [merged] drivers-dma-kconfig-add-part-number-for-topcliff.patch removed from -mm tree
Date: Fri, 05 Nov 2010 11:29:18 -0700
Message-ID: <201011051831.oA5IV0ca025689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752902Ab0KESbC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Nov 2010 14:31:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: valdis.kletnieks@vt.edu, dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/dma/Kconfig: add part number for Topcliff
has been removed from the -mm tree.  Its filename was
     drivers-dma-kconfig-add-part-number-for-topcliff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/dma/Kconfig: add part number for Topcliff
From: Valdis.Kletnieks@vt.edu

Product codenames are OK, but once an actual product name is available, it
should be referenced as well.

http://ark.intel.com/chipset.aspx?familyID=52499

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/dma/Kconfig~drivers-dma-kconfig-add-part-number-for-topcliff drivers/dma/Kconfig
--- a/drivers/dma/Kconfig~drivers-dma-kconfig-add-part-number-for-topcliff
+++ a/drivers/dma/Kconfig
@@ -200,11 +200,11 @@ config PL330_DMA
 	  platform_data for a dma-pl330 device.
 
 config PCH_DMA
-	tristate "Topcliff PCH DMA support"
+	tristate "Topcliff (Intel EG20T) PCH DMA support"
 	depends on PCI && X86
 	select DMA_ENGINE
 	help
-	  Enable support for the Topcliff PCH DMA engine.
+	  Enable support for the Topcliff (Intel EG20T) PCH DMA engine.
 
 config IMX_SDMA
 	tristate "i.MX SDMA support"
_

Patches currently in -mm which might be from valdis.kletnieks@vt.edu are


