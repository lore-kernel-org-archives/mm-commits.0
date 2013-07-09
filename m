From: akpm@linux-foundation.org
Subject: [merged]
 drivers-platform-x86-intel_ips-convert-to-module_pci_driver.patch removed
 from -mm tree
Date: Tue, 09 Jul 2013 14:04:43 -0700
Message-ID: <51dc7aeb.YeeWMLnZY5UC+TwY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab3GIVEn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 17:04:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, matthew.garrett@nebula.com, libo.chen@huawei.com, clbchenlibo.chen@huawei.com

Subject: [merged] drivers-platform-x86-intel_ips-convert-to-module_pci_driver.patch removed from -mm tree
To: clbchenlibo.chen@huawei.com,libo.chen@huawei.com,matthew.garrett@nebula.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 14:04:43 -0700


The patch titled
     Subject: drivers/platform/x86/intel_ips.c: convert to module_pci_driver
has been removed from the -mm tree.  Its filename was
     drivers-platform-x86-intel_ips-convert-to-module_pci_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Libo Chen <clbchenlibo.chen@huawei.com>
Subject: drivers/platform/x86/intel_ips.c: convert to module_pci_driver

Signed-off-by: Libo Chen <libo.chen@huawei.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/intel_ips.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/platform/x86/intel_ips.c~drivers-platform-x86-intel_ips-convert-to-module_pci_driver drivers/platform/x86/intel_ips.c
--- a/drivers/platform/x86/intel_ips.c~drivers-platform-x86-intel_ips-convert-to-module_pci_driver
+++ a/drivers/platform/x86/intel_ips.c
@@ -1731,18 +1731,7 @@ static struct pci_driver ips_pci_driver
 	.shutdown = ips_shutdown,
 };
 
-static int __init ips_init(void)
-{
-	return pci_register_driver(&ips_pci_driver);
-}
-module_init(ips_init);
-
-static void ips_exit(void)
-{
-	pci_unregister_driver(&ips_pci_driver);
-	return;
-}
-module_exit(ips_exit);
+module_pci_driver(ips_pci_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jesse Barnes <jbarnes@virtuousgeek.org>");
_

Patches currently in -mm which might be from clbchenlibo.chen@huawei.com are

origin.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch
linux-next.patch
drivers-ide-delkin_cb-convert-to-module_pci_driver.patch
drivers-atm-he-convert-to-module_pci_driver.patch
drivers-scsi-a100u2w-convert-to-module_pci_driver.patch
drivers-scsi-dc395x-convert-to-module_pci_driver.patch
drivers-scsi-dmx3191d-convert-to-module_pci_driver.patch
drivers-scsi-initio-convert-to-module_pci_driver.patch
drivers-scsi-mvumi-convert-to-module_pci_driver.patch
drivers-net-irda-donauboe-convert-to-module_pci_driver.patch

