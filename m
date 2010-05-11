From: akpm@linux-foundation.org
Subject: [merged] mtd-nand-remove-stray-endchoice-from-kconfig-help-text.patch removed from -mm tree
Date: Tue, 11 May 2010 12:17:07 -0400
Message-ID: <201005111918.o4BJIZgJ018216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757576Ab0EKTSr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 May 2010 15:18:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wferi@niif.hu, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd: nand: remove stray endchoice from Kconfig help text
has been removed from the -mm tree.  Its filename was
     mtd-nand-remove-stray-endchoice-from-kconfig-help-text.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: nand: remove stray endchoice from Kconfig help text
From: Ferenc Wagner <wferi@niif.hu>

Signed-off-by: Ferenc Wagner <wferi@niif.hu>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/Kconfig |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/mtd/nand/Kconfig~mtd-nand-remove-stray-endchoice-from-kconfig-help-text drivers/mtd/nand/Kconfig
--- a/drivers/mtd/nand/Kconfig~mtd-nand-remove-stray-endchoice-from-kconfig-help-text
+++ a/drivers/mtd/nand/Kconfig
@@ -373,8 +373,6 @@ config MTD_NAND_ATMEL_ECC_NONE
 
 	  If unsure, say N
 
-	  endchoice
