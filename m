From: akpm@linux-foundation.org
Subject: - ide-pci-delkin_cbc-pci_module_init-to-pci_register_driver.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:52:16 -0800
Message-ID: <200702282352.l1SNqGm2030979@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48228 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932628AbXB1XwZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:52:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ricknu-0@student.ltu.se, bzolnier@gmail.com, linux@dominikbrodowski.net, mm-commits@vger.kernel.org


The patch titled
     ide/pci/delkin_cb.c: pci_module_init to pci_register_driver
has been removed from the -mm tree.  Its filename was
     ide-pci-delkin_cbc-pci_module_init-to-pci_register_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ide/pci/delkin_cb.c: pci_module_init to pci_register_driver
From: Richard Knutsson <ricknu-0@student.ltu.se>

Convert pci_module_init() to pci_register_driver().

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/pci/delkin_cb.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ide/pci/delkin_cb.c~ide-pci-delkin_cbc-pci_module_init-to-pci_register_driver drivers/ide/pci/delkin_cb.c
--- a/drivers/ide/pci/delkin_cb.c~ide-pci-delkin_cbc-pci_module_init-to-pci_register_driver
+++ a/drivers/ide/pci/delkin_cb.c
@@ -122,7 +122,7 @@ static struct pci_driver driver = {
 static int
 delkin_cb_init (void)
 {
-	return pci_module_init(&driver);
+	return pci_register_driver(&driver);
 }
 
 static void
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

mtd-maps-ck804xromc-pci_module_init-to-pci_register_driver.patch
drivers-net-vioc-vioc_driverc-replace-pci_module_init-with-pci_register_driver.patch
drivers-scsi-aic7xxx_old-convert-to-generic-boolean-values.patch
