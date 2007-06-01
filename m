From: akpm@linux-foundation.org
Subject: - add-select-phylib-to-the-ucc_geth-kconfig-option.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:46:58 -0700
Message-ID: <200706011746.l51HkvwM015096@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761288AbXFARri (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:47:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.altenberg@linutronix.de, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     Add select PHYLIB to the UCC_GETH Kconfig option
has been removed from the -mm tree.  Its filename was
     add-select-phylib-to-the-ucc_geth-kconfig-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add select PHYLIB to the UCC_GETH Kconfig option
From: Jan Altenberg <jan.altenberg@linutronix.de>

ucc_geth has been migrated to use the common phylib code. So lets add a
'select PHYLIB' to the UCC_GETH Kconfig entry.

Signed-off-by: Jan Altenberg <jan.altenberg@linutronix.de>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/Kconfig~add-select-phylib-to-the-ucc_geth-kconfig-option drivers/net/Kconfig
--- a/drivers/net/Kconfig~add-select-phylib-to-the-ucc_geth-kconfig-option
+++ a/drivers/net/Kconfig
@@ -2280,6 +2280,7 @@ config GFAR_NAPI
 config UCC_GETH
 	tristate "Freescale QE Gigabit Ethernet"
 	depends on QUICC_ENGINE
+	select PHYLIB
 	help
 	  This driver supports the Gigabit Ethernet mode of the QUICC Engine,
 	  which is available on some Freescale SOCs.
_

Patches currently in -mm which might be from jan.altenberg@linutronix.de are

origin.patch
