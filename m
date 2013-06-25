From: akpm@linux-foundation.org
Subject: [merged]
 drivers-media-pci-dm1105-dm1105-convert-to-module_pci_driver.patch removed
 from -mm tree
Date: Tue, 25 Jun 2013 12:22:46 -0700
Message-ID: <51c9ee06.YlbaqazKZGKffxml%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42209 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3FYTWr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 15:22:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mchehab@redhat.com, libo.chen@huawei.com, kosio.dimitrov@gmail.com, clbchenlibo.chen@huawei.com

Subject: [merged] drivers-media-pci-dm1105-dm1105-convert-to-module_pci_driver.patch removed from -mm tree
To: clbchenlibo.chen@huawei.com,kosio.dimitrov@gmail.com,libo.chen@huawei.com,mchehab@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 12:22:46 -0700


The patch titled
     Subject: drivers/media/pci/dm1105/dm1105.c: convert to module_pci_driver
has been removed from the -mm tree.  Its filename was
     drivers-media-pci-dm1105-dm1105-convert-to-module_pci_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Libo Chen <clbchenlibo.chen@huawei.com>
Subject: drivers/media/pci/dm1105/dm1105.c: convert to module_pci_driver

Signed-off-by: Libo Chen <libo.chen@huawei.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/pci/b2c2/flexcop-pci.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/media/pci/b2c2/flexcop-pci.c~drivers-media-pci-dm1105-dm1105-convert-to-module_pci_driver drivers/media/pci/b2c2/flexcop-pci.c
--- a/drivers/media/pci/b2c2/flexcop-pci.c~drivers-media-pci-dm1105-dm1105-convert-to-module_pci_driver
+++ a/drivers/media/pci/b2c2/flexcop-pci.c
@@ -432,18 +432,7 @@ static struct pci_driver flexcop_pci_dri
 	.remove   = flexcop_pci_remove,
 };
 
-static int __init flexcop_pci_module_init(void)
-{
-	return pci_register_driver(&flexcop_pci_driver);
-}
-
-static void __exit flexcop_pci_module_exit(void)
-{
-	pci_unregister_driver(&flexcop_pci_driver);
-}
-
-module_init(flexcop_pci_module_init);
-module_exit(flexcop_pci_module_exit);
+module_pci_driver(flexcop_pci_driver);
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_NAME);
_

Patches currently in -mm which might be from clbchenlibo.chen@huawei.com are

linux-next.patch
drivers-platform-x86-intel_ips-convert-to-module_pci_driver.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
drivers-ide-delkin_cb-convert-to-module_pci_driver.patch
drivers-atm-he-convert-to-module_pci_driver.patch
drivers-scsi-a100u2w-convert-to-module_pci_driver.patch
drivers-scsi-dc395x-convert-to-module_pci_driver.patch
drivers-scsi-dmx3191d-convert-to-module_pci_driver.patch
drivers-scsi-initio-convert-to-module_pci_driver.patch
drivers-scsi-mvumi-convert-to-module_pci_driver.patch
drivers-net-irda-donauboe-convert-to-module_pci_driver.patch
drivers-cdrom-gdromc-fix-device-number-leak.patch
drivers-memstick-host-r592-convert-to-module_pci_driver.patch

