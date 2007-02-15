From: akpm@linux-foundation.org
Subject: + atl1-drop-net_pci-from-kconfig.patch added to -mm tree
Date: Wed, 14 Feb 2007 21:48:34 -0800
Message-ID: <200702150548.l1F5mYKw021237@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35713 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbXBOFss (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 00:48:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jacliburn@bellsouth.net, csnook@redhat.com


The patch titled
     atl1: drop NET_PCI from Kconfig
has been added to the -mm tree.  Its filename is
     atl1-drop-net_pci-from-kconfig.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
atl1-drop-net_pci-from-kconfig.patch
atl1-read-mac-address-from-register.patch
atl1-remove-unused-define.patch
atl1-add-l1-device-id-to-pci_ids-then-use-it.patch
atl1-bump-version-number.patch
