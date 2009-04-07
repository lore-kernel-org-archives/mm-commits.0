From: akpm@linux-foundation.org
Subject: [merged] blackfin-serial-driver-update-kgdb-uart-config-name.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:10:03 -0700
Message-ID: <200904071910.n37JA3mA012637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757831AbZDGT5S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:57:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, cooloney@kernel.org, mm-commits@vger.kernel.org


The patch titled
     blackfin serial driver: update KGDB UART config name
has been removed from the -mm tree.  Its filename was
     blackfin-serial-driver-update-kgdb-uart-config-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin serial driver: update KGDB UART config name
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/Kconfig~blackfin-serial-driver-update-kgdb-uart-config-name drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~blackfin-serial-driver-update-kgdb-uart-config-name
+++ a/drivers/serial/Kconfig
@@ -700,7 +700,7 @@ choice
 
 config SERIAL_BFIN_DMA
 	bool "DMA mode"
-	depends on !DMA_UNCACHED_NONE && !KGDB_UART
+	depends on !DMA_UNCACHED_NONE && !KGDB_SERIAL_CONSOLE
 	help
 	  This driver works under DMA mode. If this option is selected, the
 	  blackfin simple dma driver is also enabled.
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
linux-next.patch

