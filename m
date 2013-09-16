From: akpm@linux-foundation.org
Subject: [merged] drivers-atm-he-convert-to-module_pci_driver.patch
 removed from -mm tree
Date: Mon, 16 Sep 2013 12:50:14 -0700
Message-ID: <523760f6.A5yDtVfxXLgfLRsx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56722 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab3IPTuP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Sep 2013 15:50:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, libo.chen@huawei.com, chas@cmf.nrl.navy.mil, clbchenlibo.chen@huawei.com

Subject: [merged] drivers-atm-he-convert-to-module_pci_driver.patch removed from -mm tree
To: clbchenlibo.chen@huawei.com,chas@cmf.nrl.navy.mil,libo.chen@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 16 Sep 2013 12:50:14 -0700


The patch titled
     Subject: drivers/atm/he.c: convert to module_pci_driver
has been removed from the -mm tree.  Its filename was
     drivers-atm-he-convert-to-module_pci_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Libo Chen <clbchenlibo.chen@huawei.com>
Subject: drivers/atm/he.c: convert to module_pci_driver

Signed-off-by: Libo Chen <libo.chen@huawei.com>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/he.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/atm/he.c~drivers-atm-he-convert-to-module_pci_driver drivers/atm/he.c
--- a/drivers/atm/he.c~drivers-atm-he-convert-to-module_pci_driver
+++ a/drivers/atm/he.c
@@ -2872,15 +2872,4 @@ static struct pci_driver he_driver = {
 	.id_table =	he_pci_tbl,
 };
 
-static int __init he_init(void)
-{
-	return pci_register_driver(&he_driver);
-}
-
-static void __exit he_cleanup(void)
-{
-	pci_unregister_driver(&he_driver);
-}
