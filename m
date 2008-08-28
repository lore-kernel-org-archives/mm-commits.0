From: akpm@linux-foundation.org
Subject: - netdev-blackfin-emac-driver-the-bf526-also-supports-the-mac-so-updates-things-accordingly.patch removed from -mm tree
Date: Thu, 28 Aug 2008 14:48:43 -0700
Message-ID: <200808282148.m7SLmhux016119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753148AbYH1Vsw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 17:48:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, mm-commits@vger.kernel.org


The patch titled
     netdev: blackfin EMAC Driver: the BF526 also supports the MAC, so updates things accordingly
has been removed from the -mm tree.  Its filename was
     netdev-blackfin-emac-driver-the-bf526-also-supports-the-mac-so-updates-things-accordingly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: netdev: blackfin EMAC Driver: the BF526 also supports the MAC, so updates things accordingly
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/net/Kconfig~netdev-blackfin-emac-driver-the-bf526-also-supports-the-mac-so-updates-things-accordingly drivers/net/Kconfig
--- a/drivers/net/Kconfig~netdev-blackfin-emac-driver-the-bf526-also-supports-the-mac-so-updates-things-accordingly
+++ a/drivers/net/Kconfig
@@ -822,14 +822,14 @@ config ULTRA32
 	  will be called smc-ultra32.
 
 config BFIN_MAC
-	tristate "Blackfin 527/536/537 on-chip mac support"
-	depends on NET_ETHERNET && (BF527 || BF537 || BF536)
+	tristate "Blackfin on-chip MAC support"
+	depends on NET_ETHERNET && (BF526 || BF527 || BF536 || BF537)
 	select CRC32
 	select MII
 	select PHYLIB
 	select BFIN_MAC_USE_L1 if DMA_UNCACHED_NONE
 	help
-	  This is the driver for blackfin on-chip mac device. Say Y if you want it
+	  This is the driver for Blackfin on-chip mac device. Say Y if you want it
 	  compiled into the kernel. This driver is also available as a module
 	  ( = code which can be inserted in and removed from the running kernel
 	  whenever you want). The module will be called bfin_mac.
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

linux-next.patch
mtd-maps-make-uclinux-mapping-driver-depend-on-mtd_ram-since-it-only-probes-that.patch

