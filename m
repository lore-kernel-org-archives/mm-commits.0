From: akpm@linux-foundation.org
Subject: + add-select-phylib-to-the-ucc_geth-kconfig-option.patch added to -mm tree
Date: Thu, 24 May 2007 13:50:29 -0700
Message-ID: <200705242050.l4OKoTdm002295@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063AbXEXUvN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 16:51:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jan.altenberg@linutronix.de, jeff@garzik.org


The patch titled
     Add select PHYLIB to the UCC_GETH Kconfig option
has been added to the -mm tree.  Its filename is
     add-select-phylib-to-the-ucc_geth-kconfig-option.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+)

diff -puN drivers/net/Kconfig~add-select-phylib-to-the-ucc_geth-kconfig-option drivers/net/Kconfig
--- a/drivers/net/Kconfig~add-select-phylib-to-the-ucc_geth-kconfig-option
+++ a/drivers/net/Kconfig
@@ -2332,6 +2332,7 @@ config GFAR_NAPI
 config UCC_GETH
 	tristate "Freescale QE Gigabit Ethernet"
 	depends on QUICC_ENGINE
+	select PHYLIB
 	help
 	  This driver supports the Gigabit Ethernet mode of the QUICC Engine,
 	  which is available on some Freescale SOCs.
_

Patches currently in -mm which might be from jan.altenberg@linutronix.de are

add-select-phylib-to-the-ucc_geth-kconfig-option.patch
