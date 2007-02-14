From: akpm@linux-foundation.org
Subject: + net-wan-pc300tooc-pci_module_init-to-pci_register_driver.patch added to -mm tree
Date: Wed, 14 Feb 2007 14:53:31 -0800
Message-ID: <200702142253.l1EMrVHL011904@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49972 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964786AbXBNWxk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 17:53:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ricknu-0@student.ltu.se


The patch titled
     net/wan/pc300too.c: pci_module_init to pci_register_driver
has been added to the -mm tree.  Its filename is
     net-wan-pc300tooc-pci_module_init-to-pci_register_driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
drivers-scsi-aic7xxx-convert-to-generic-boolean-values.patch
drivers-scsi-aic7xxx_old-convert-to-generic-boolean-values.patch
ide-pci-delkin_cbc-pci_module_init-to-pci_register_driver.patch
mtd-maps-ck804xromc-pci_module_init-to-pci_register_driver.patch
net-wan-pc300tooc-pci_module_init-to-pci_register_driver.patch
