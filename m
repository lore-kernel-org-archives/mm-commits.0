From: akpm@linux-foundation.org
Subject: + ide-pci-delkin_cbc-pci_module_init-to-pci_register_driver.patch added to -mm tree
Date: Wed, 14 Feb 2007 14:53:25 -0800
Message-ID: <200702142253.l1EMrPqD011895@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49963 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932445AbXBNWxf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 17:53:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ricknu-0@student.ltu.se, bzolnier@gmail.com, linux@dominikbrodowski.net


The patch titled
     ide/pci/delkin_cb.c: pci_module_init to pci_register_driver
has been added to the -mm tree.  Its filename is
     ide-pci-delkin_cbc-pci_module_init-to-pci_register_driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
git-dvb.patch
drivers-scsi-aic7xxx-convert-to-generic-boolean-values.patch
drivers-scsi-aic7xxx_old-convert-to-generic-boolean-values.patch
ide-pci-delkin_cbc-pci_module_init-to-pci_register_driver.patch
mtd-maps-ck804xromc-pci_module_init-to-pci_register_driver.patch
net-wan-pc300tooc-pci_module_init-to-pci_register_driver.patch
