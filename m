From: akpm@linux-foundation.org
Subject: [folded-dropped] rtc-tps65910-add-rtc-driver-for-tps65910-pmic-rtc-fix.patch removed from -mm tree
Date: Thu, 04 Oct 2012 16:59:24 -0700
Message-ID: <20121004235925.C80335C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:57982 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab2JDX72 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 19:59:28 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so76398wib.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 16:59:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbyravarasu@nvidia.com, a.zummo@towertech.it, broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: tps65910: change RTC driver name as per mfd
has been removed from the -mm tree.  Its filename was
     rtc-tps65910-add-rtc-driver-for-tps65910-pmic-rtc-fix.patch

This patch was dropped because it was folded into rtc-tps65910-add-rtc-driver-for-tps65910-pmic-rtc.patch

------------------------------------------------------
From: Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: rtc: tps65910: change RTC driver name as per mfd

As TPS65910 mfd uses "tps65910-rtc" as driver name, change the
driver name in the RTC driver to match with the same.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps65910.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-tps65910.c~rtc-tps65910-add-rtc-driver-for-tps65910-pmic-rtc-fix drivers/rtc/rtc-tps65910.c
--- a/drivers/rtc/rtc-tps65910.c~rtc-tps65910-add-rtc-driver-for-tps65910-pmic-rtc-fix
+++ a/drivers/rtc/rtc-tps65910.c
@@ -341,7 +341,7 @@ static struct platform_driver tps65910_r
 	.remove		= __devexit_p(tps65910_rtc_remove),
 	.driver		= {
 		.owner	= THIS_MODULE,
-		.name	= "rtc-tps65910",
+		.name	= "tps65910-rtc",
 		.pm	= DEV_PM_OPS,
 	},
 };
_

Patches currently in -mm which might be from vbyravarasu@nvidia.com are

origin.patch
rtc-tps65910-add-rtc-driver-for-tps65910-pmic-rtc.patch
rtc-kconfig-remove-unnecessary-dependencies.patch
rtc-rc5t583-add-ricoh-rc5t583-rtc-driver.patch
drivers-rtc-rtc-tps65910c-use-platform_get_irq-to-get-rtc-irq-details.patch

