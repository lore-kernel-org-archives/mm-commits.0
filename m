From: akpm@linux-foundation.org
Subject: +
 drivers-iommu-omap-iopgtableh-remove-unneeded-cast-of-void.patch added to
 -mm tree
Date: Thu, 19 Sep 2013 15:47:54 -0700
Message-ID: <523b7f1a.TFEsoOEhqmfR1aRY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab3ISWrz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 18:47:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony@atomide.com, joro@8bytes.org, jg1.han@samsung.com

Subject: + drivers-iommu-omap-iopgtableh-remove-unneeded-cast-of-void.patch added to -mm tree
To: jg1.han@samsung.com,joro@8bytes.org,tony@atomide.com
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 15:47:54 -0700


The patch titled
     Subject: drivers/iommu/omap-iopgtable.h: remove unneeded cast of void*
has been added to the -mm tree.  Its filename is
     drivers-iommu-omap-iopgtableh-remove-unneeded-cast-of-void.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-iommu-omap-iopgtableh-remove-unneeded-cast-of-void.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-iommu-omap-iopgtableh-remove-unneeded-cast-of-void.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
drivers-iommu-omap-iopgtableh-remove-unneeded-cast-of-void.patch
backlight-lp855x_bl-support-new-lp8555-device.patch
backlight-lm3630-apply-chip-revision.patch
backlight-ld9040-staticize-local-variable-gamma_table.patch
backlight-lm3639-dont-mix-different-enum-types.patch
backlight-lp8788-staticize-default_bl_config.patch
backlight-use-dev_get_platdata.patch
drivers-rtc-rtc-ds1307c-release-irq-on-error.patch
drivers-rtc-rtc-isl1208c-remove-redundant-checks.patch
drivers-rtc-rtc-max6900c-remove-redundant-checks.patch
drivers-rtc-rtc-vt8500c-fix-return-value.patch
drivers-rtc-rtc-at91rm9200c-use-devm_-apis.patch
drivers-rtc-rtc-isl1208c-use-devm_-apis.patch
drivers-rtc-rtc-sirfsocc-use-devm_rtc_device_register.patch
drivers-rtc-rtc-cmosc-remove-redundant-dev_set_drvdata.patch
drivers-rtc-rtc-mrstc-remove-redundant-dev_set_drvdata.patch
drivers-rtc-rtc-vr41xxc-fix-checkpatch-warnings.patch
drivers-rtc-rtc-sirfsocc-remove-unneeded-casts-of-void.patch
drivers-char-xilinx_hwicap-xilinx_hwicapc-remove-unneeded-cast-of-void.patch
w1-w1-gpio-use-dev_get_platdata.patch
w1-ds1wm-use-dev_get_platdata.patch
linux-next.patch

