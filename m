From: akpm@linux-foundation.org
Subject: - hp100-convert-pci_module_init-to-pci_register_driver.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:53:07 -0800
Message-ID: <200702071953.l17Jr7Hh025297@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33752 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422899AbXBGTxe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:53:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ricknu-0@student.ltu.se, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     hp100: convert pci_module_init() to pci_register_driver()
has been removed from the -mm tree.  Its filename was
     hp100-convert-pci_module_init-to-pci_register_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hp100: convert pci_module_init() to pci_register_driver()
From: Richard Knutsson <ricknu-0@student.ltu.se>

Convert pci_module_init() to pci_register_driver().

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/hp100.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/hp100.c~hp100-convert-pci_module_init-to-pci_register_driver drivers/net/hp100.c
--- a/drivers/net/hp100.c~hp100-convert-pci_module_init-to-pci_register_driver
+++ a/drivers/net/hp100.c
@@ -3034,7 +3034,7 @@ static int __init hp100_module_init(void
 		goto out2;
 #endif
 #ifdef CONFIG_PCI
-	err = pci_module_init(&hp100_pci_driver);
+	err = pci_register_driver(&hp100_pci_driver);
 	if (err && err != -ENODEV)
 		goto out3;
 #endif
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

git-dvb.patch
git-netdev-all.patch
drivers-scsi-buslogic-replace-boolean-by-bool.patch
git-cryptodev.patch
drivers-block-dac960-converted-boolean-to-bool.patch
include-linux-kernelh-remove-labs.patch
drivers-isdn-hardware-eicon-convert-to-generic-boolean-values.patch
drivers-isdn-hisax-convert-to-generic-boolean-values.patch
drivers-video-sis-convert-to-generic-boolean.patch
