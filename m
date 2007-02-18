From: akpm@linux-foundation.org
Subject: - net-wan-pc300tooc-pci_module_init-to-pci_register_driver.patch removed from -mm tree
Date: Sat, 17 Feb 2007 18:14:52 -0800
Message-ID: <200702180214.l1I2Eq4N008316@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55640 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993090AbXBRCPE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 21:15:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ricknu-0@student.ltu.se, khc@pm.waw.pl, mm-commits@vger.kernel.org


The patch titled
     net/wan/pc300too.c: pci_module_init to pci_register_driver
has been removed from the -mm tree.  Its filename was
     net-wan-pc300tooc-pci_module_init-to-pci_register_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: net/wan/pc300too.c: pci_module_init to pci_register_driver
From: Richard Knutsson <ricknu-0@student.ltu.se>

Convert pci_module_init() to pci_register_driver().

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wan/pc300too.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wan/pc300too.c~net-wan-pc300tooc-pci_module_init-to-pci_register_driver drivers/net/wan/pc300too.c
--- a/drivers/net/wan/pc300too.c~net-wan-pc300tooc-pci_module_init-to-pci_register_driver
+++ a/drivers/net/wan/pc300too.c
@@ -542,7 +542,7 @@ static int __init pc300_init_module(void
 
 	CLOCK_BASE = use_crystal_clock ? 24576000 : pci_clock_freq;
 
-	return pci_module_init(&pc300_pci_driver);
+	return pci_register_driver(&pc300_pci_driver);
 }
 
 
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

origin.patch
git-dvb.patch
ide-pci-delkin_cbc-pci_module_init-to-pci_register_driver.patch
mtd-maps-ck804xromc-pci_module_init-to-pci_register_driver.patch
git-netdev-all.patch
git-scsi-misc.patch
drivers-scsi-aic7xxx_old-convert-to-generic-boolean-values.patch
