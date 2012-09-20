From: akpm@linux-foundation.org
Subject: + rtc-tps65910-add-rtc-driver-for-tps65910-pmic-rtc-fix.patch added to -mm tree
Date: Thu, 20 Sep 2012 14:26:29 -0700
Message-ID: <20120920212630.2E71C5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:48335 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab2ITV0d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Sep 2012 17:26:33 -0400
Received: by lbbge1 with SMTP id ge1so183915lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 20 Sep 2012 14:26:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vbyravarasu@nvidia.com, a.zummo@towertech.it, broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com


The patch titled
     Subject: rtc: tps65910: change RTC driver name as per mfd
has been added to the -mm tree.  Its filename is
     rtc-tps65910-add-rtc-driver-for-tps65910-pmic-rtc-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
rtc-tps65910-add-rtc-driver-for-tps65910-pmic-rtc.patch
rtc-tps65910-add-rtc-driver-for-tps65910-pmic-rtc-fix.patch
rtc-kconfig-remove-unnecessary-dependencies.patch
rtc-rc5t583-add-ricoh-rc5t583-rtc-driver.patch
coredump-prevent-double-free-on-an-error-path-in-core-dumper.patch

