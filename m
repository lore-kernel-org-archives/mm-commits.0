From: akpm@linux-foundation.org
Subject: - drivers-mfd-sm501c-replace-pci_module_init-with-pci_register_driver.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:55:11 -0800
Message-ID: <200702282355.l1SNtBQm031256@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48570 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932765AbXB1Xz0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:55:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ricknu-0@student.ltu.se, ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     drivers/mfd/sm501.c: replace pci_module_init with pci_register_driver
has been removed from the -mm tree.  Its filename was
     drivers-mfd-sm501c-replace-pci_module_init-with-pci_register_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/mfd/sm501.c: replace pci_module_init with pci_register_driver
From: Richard Knutsson <ricknu-0@student.ltu.se>

Replace pci_module_init with pci_register_driver

Signed-off-by: Richard Knutson <ricknu-0@student.ltu.se>
Acked-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sm501.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mfd/sm501.c~drivers-mfd-sm501c-replace-pci_module_init-with-pci_register_driver drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~drivers-mfd-sm501c-replace-pci_module_init-with-pci_register_driver
+++ a/drivers/mfd/sm501.c
@@ -1131,7 +1131,7 @@ static struct platform_driver sm501_plat
 static int __init sm501_base_init(void)
 {
 	platform_driver_register(&sm501_plat_drv);
-	return pci_module_init(&sm501_pci_drv);
+	return pci_register_driver(&sm501_pci_drv);
 }
 
 static void __exit sm501_base_exit(void)
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

mtd-maps-ck804xromc-pci_module_init-to-pci_register_driver.patch
drivers-net-vioc-vioc_driverc-replace-pci_module_init-with-pci_register_driver.patch
drivers-scsi-aic7xxx_old-convert-to-generic-boolean-values.patch
