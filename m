From: akpm@linux-foundation.org
Subject: [merged] mmc-bfin_sdh-drop-redundant-mmc-depend-string.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:07:54 -0800
Message-ID: <201003091907.o29J7sjU031392@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755708Ab0CITWB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, linux-mmc@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     mmc: bfin_sdh: drop redundant MMC depend string
has been removed from the -mm tree.  Its filename was
     mmc-bfin_sdh-drop-redundant-mmc-depend-string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: bfin_sdh: drop redundant MMC depend string
From: Mike Frysinger <vapier@gentoo.org>

The host/Kconfig file is only included when MMC is selected.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/Kconfig~mmc-bfin_sdh-drop-redundant-mmc-depend-string drivers/mmc/host/Kconfig
--- a/drivers/mmc/host/Kconfig~mmc-bfin_sdh-drop-redundant-mmc-depend-string
+++ a/drivers/mmc/host/Kconfig
@@ -396,7 +396,7 @@ config MMC_VIA_SDMMC
 
 config SDH_BFIN
 	tristate "Blackfin Secure Digital Host support"
-	depends on MMC && ((BF54x && !BF544) || (BF51x && !BF512))
+	depends on (BF54x && !BF544) || (BF51x && !BF512)
 	help
 	  If you say yes here you will get support for the Blackfin on-chip
 	  Secure Digital Host interface.  This includes support for MMC and
_

Patches currently in -mm which might be from vapier@gentoo.org are

linux-next.patch
fbdev-bf54x-lq043fb-bfin-t350mcqb-fb-drop-custom-mmap-handler.patch
blackfin-remove-the-obsolete-and-unnecessary-dma-api-comments.patch

