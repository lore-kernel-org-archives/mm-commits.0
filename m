From: akpm@linux-foundation.org
Subject: [merged] drivers-mfd-lpc_ich-convert-to-module_pci_driver.patch
 removed from -mm tree
Date: Tue, 25 Jun 2013 12:22:38 -0700
Message-ID: <51c9edfe.uZuqrJ5eLAmvPflR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42195 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3FYTWj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 15:22:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sameo@linux.intel.com, ptyser@xes-inc.com, libo.chen@huawei.com, lee.jones@linaro.org, clbchenlibo.chen@huawei.com

Subject: [merged] drivers-mfd-lpc_ich-convert-to-module_pci_driver.patch removed from -mm tree
To: clbchenlibo.chen@huawei.com,lee.jones@linaro.org,libo.chen@huawei.com,ptyser@xes-inc.com,sameo@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 12:22:38 -0700


The patch titled
     Subject: drivers/mfd/lpc_ich.c: convert to module_pci_driver
has been removed from the -mm tree.  Its filename was
     drivers-mfd-lpc_ich-convert-to-module_pci_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Libo Chen <clbchenlibo.chen@huawei.com>
Subject: drivers/mfd/lpc_ich.c: convert to module_pci_driver

Signed-off-by: Libo Chen <libo.chen@huawei.com>
Cc: Peter Tyser <ptyser@xes-inc.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/lpc_ich.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/mfd/lpc_ich.c~drivers-mfd-lpc_ich-convert-to-module_pci_driver drivers/mfd/lpc_ich.c
--- a/drivers/mfd/lpc_ich.c~drivers-mfd-lpc_ich-convert-to-module_pci_driver
+++ a/drivers/mfd/lpc_ich.c
@@ -983,18 +983,7 @@ static struct pci_driver lpc_ich_driver
 	.remove		= lpc_ich_remove,
 };
 
-static int __init lpc_ich_init(void)
-{
-	return pci_register_driver(&lpc_ich_driver);
-}
-
-static void __exit lpc_ich_exit(void)
-{
-	pci_unregister_driver(&lpc_ich_driver);
-}
-
-module_init(lpc_ich_init);
-module_exit(lpc_ich_exit);
+module_pci_driver(lpc_ich_driver);
 
 MODULE_AUTHOR("Aaron Sierra <asierra@xes-inc.com>");
 MODULE_DESCRIPTION("LPC interface for Intel ICH");
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

