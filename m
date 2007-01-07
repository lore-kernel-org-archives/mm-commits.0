From: akpm@osdl.org
Subject: - pata_optidma-typo-in-kconfig.patch removed from -mm tree
Date: Sun, 07 Jan 2007 00:00:29 -0800
Message-ID: <200701070800.l0780TkC013195@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41072 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932495AbXAGIAo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 03:00:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, alan@redhat.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     pata_optidma: typo in Kconfig
has been removed from the -mm tree.  Its filename was
     pata_optidma-typo-in-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_optidma: typo in Kconfig
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/Kconfig~pata_optidma-typo-in-kconfig drivers/ata/Kconfig
--- a/drivers/ata/Kconfig~pata_optidma-typo-in-kconfig
+++ a/drivers/ata/Kconfig
@@ -381,7 +381,7 @@ config PATA_OPTI
 	  If unsure, say N.
 
 config PATA_OPTIDMA
-	tristate "OPTI FireStar PATA support (Veyr Experimental)"
+	tristate "OPTI FireStar PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables DMA/PIO support for the later OPTi
_

Patches currently in -mm which might be from adobriyan@gmail.com are

git-dvb.patch
git-mtd.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
