From: akpm@linux-foundation.org
Subject: [merged]
 drivers-media-pci-mantis-mantis_cards-convert-to-module_pci_driver.patch
 removed from -mm tree
Date: Tue, 25 Jun 2013 12:22:44 -0700
Message-ID: <51c9ee04.88gmDOwp1lBen9fO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42207 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3FYTWp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 15:22:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mchehab@redhat.com, libo.chen@huawei.com, clbchenlibo.chen@huawei.com

Subject: [merged] drivers-media-pci-mantis-mantis_cards-convert-to-module_pci_driver.patch removed from -mm tree
To: clbchenlibo.chen@huawei.com,libo.chen@huawei.com,mchehab@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 12:22:44 -0700


The patch titled
     Subject: drivers/media/pci/mantis/mantis_cards.c: convert to module_pci_driver
has been removed from the -mm tree.  Its filename was
     drivers-media-pci-mantis-mantis_cards-convert-to-module_pci_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Libo Chen <clbchenlibo.chen@huawei.com>
Subject: drivers/media/pci/mantis/mantis_cards.c: convert to module_pci_driver

Signed-off-by: Libo Chen <libo.chen@huawei.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/pci/mantis/mantis_cards.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/media/pci/mantis/mantis_cards.c~drivers-media-pci-mantis-mantis_cards-convert-to-module_pci_driver drivers/media/pci/mantis/mantis_cards.c
--- a/drivers/media/pci/mantis/mantis_cards.c~drivers-media-pci-mantis-mantis_cards-convert-to-module_pci_driver
+++ a/drivers/media/pci/mantis/mantis_cards.c
@@ -290,18 +290,7 @@ static struct pci_driver mantis_pci_driv
 	.remove		= mantis_pci_remove,
 };
 
-static int mantis_init(void)
-{
-	return pci_register_driver(&mantis_pci_driver);
-}
-
-static void mantis_exit(void)
-{
-	return pci_unregister_driver(&mantis_pci_driver);
-}
-
-module_init(mantis_init);
-module_exit(mantis_exit);
+module_pci_driver(mantis_pci_driver);
 
 MODULE_DESCRIPTION("MANTIS driver");
 MODULE_AUTHOR("Manu Abraham");
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

