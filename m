From: akpm@osdl.org
Subject: + pata_optidma-typo-in-kconfig.patch added to -mm tree
Date: Thu, 04 Jan 2007 13:34:50 -0800
Message-ID: <200701042134.l04LYocN031982@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:55602 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965084AbXADVe7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 16:34:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, alan@redhat.com


The patch titled
     pata_optidma: typo in Kconfig
has been added to the -mm tree.  Its filename is
     pata_optidma-typo-in-kconfig.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_optidma: typo in Kconfig
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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
pata_optidma-typo-in-kconfig.patch
git-mtd.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
