From: akpm@linux-foundation.org
Subject: - atl1-drop-net_pci-from-kconfig.patch removed from -mm tree
Date: Sat, 17 Feb 2007 18:14:56 -0800
Message-ID: <200702180214.l1I2Eu8J008319@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55651 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993096AbXBRCPK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 21:15:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jacliburn@bellsouth.net, csnook@redhat.com, mm-commits@vger.kernel.org


The patch titled
     atl1: drop NET_PCI from Kconfig
has been removed from the -mm tree.  Its filename was
     atl1-drop-net_pci-from-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atl1: drop NET_PCI from Kconfig
From: Jay Cliburn <jacliburn@bellsouth.net>

The atl1 driver doesn't need NET_PCI.  Remove it from Kconfig.  Noticed by
Chad Sprouse.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Chris Snook <csnook@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/Kconfig~atl1-drop-net_pci-from-kconfig drivers/net/Kconfig
--- a/drivers/net/Kconfig~atl1-drop-net_pci-from-kconfig
+++ a/drivers/net/Kconfig
@@ -2337,7 +2337,7 @@ config QLA3XXX
 
 config ATL1
 	tristate "Attansic L1 Gigabit Ethernet support (EXPERIMENTAL)"
-	depends on NET_PCI && PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL
 	select CRC32
 	select MII
 	help
_

Patches currently in -mm which might be from jacliburn@bellsouth.net are

origin.patch
git-netdev-all.patch
