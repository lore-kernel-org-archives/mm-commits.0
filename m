From: akpm@linux-foundation.org
Subject: [merged]
 drivers-iommu-omap-iopgtableh-remove-unneeded-cast-of-void.patch removed
 from -mm tree
Date: Wed, 13 Nov 2013 12:37:04 -0800
Message-ID: <5283e2f0.O9AHmS9lwZqCFYAd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab3KMUhE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:37:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony@atomide.com, joro@8bytes.org, jg1.han@samsung.com

Subject: [merged] drivers-iommu-omap-iopgtableh-remove-unneeded-cast-of-void.patch removed from -mm tree
To: jg1.han@samsung.com,joro@8bytes.org,tony@atomide.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:37:04 -0800


The patch titled
     Subject: drivers/iommu/omap-iopgtable.h: remove unneeded cast of void*
has been removed from the -mm tree.  Its filename was
     drivers-iommu-omap-iopgtableh-remove-unneeded-cast-of-void.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/iommu/omap-iopgtable.h: remove unneeded cast of void*

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/omap-iopgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/iommu/omap-iopgtable.h~drivers-iommu-omap-iopgtableh-remove-unneeded-cast-of-void drivers/iommu/omap-iopgtable.h
--- a/drivers/iommu/omap-iopgtable.h~drivers-iommu-omap-iopgtableh-remove-unneeded-cast-of-void
+++ a/drivers/iommu/omap-iopgtable.h
@@ -95,4 +95,4 @@ static inline phys_addr_t omap_iommu_tra
 #define iopte_offset(iopgd, da)	(iopgd_page_vaddr(iopgd) + iopte_index(da))
 
 #define to_iommu(dev)							\
-	((struct omap_iommu *)platform_get_drvdata(to_platform_device(dev)))
+	(platform_get_drvdata(to_platform_device(dev)))
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
drivers-block-sx8c-use-module_pci_driver.patch
drivers-block-sx8c-remove-unnecessary-pci_set_drvdata.patch
linux-next.patch
drivers-rtc-rtc-hid-sensor-timec-use-dev_get_platdata.patch
w1-w1-gpio-use-dev_get_platdata.patch

