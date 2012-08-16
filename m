From: akpm@linux-foundation.org
Subject: + thermal-exynos-remove-duplicate-inclusion-of-errh-header-file.patch added to -mm tree
Date: Thu, 16 Aug 2012 11:39:57 -0700
Message-ID: <20120816183958.C14915C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:39812 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2HPSkB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Aug 2012 14:40:01 -0400
Received: by eekd4 with SMTP id d4so150088eek.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Aug 2012 11:40:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, guenter.roeck@ericsson.com, len.brown@intel.com, lenb@kernel.org, sachin.kamat@samsung.com


The patch titled
     Subject: drivers/thermal/exynos_thermal.c: remove duplicate inclusion of err.h header file
has been added to the -mm tree.  Its filename is
     thermal-exynos-remove-duplicate-inclusion-of-errh-header-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/thermal/exynos_thermal.c: remove duplicate inclusion of err.h header file

err.h header file was included twice.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/exynos_thermal.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/thermal/exynos_thermal.c~thermal-exynos-remove-duplicate-inclusion-of-errh-header-file drivers/thermal/exynos_thermal.c
--- a/drivers/thermal/exynos_thermal.c~thermal-exynos-remove-duplicate-inclusion-of-errh-header-file
+++ a/drivers/thermal/exynos_thermal.c
@@ -33,7 +33,6 @@
 #include <linux/kobject.h>
 #include <linux/io.h>
 #include <linux/mutex.h>
-#include <linux/err.h>
 #include <linux/platform_data/exynos_thermal.h>
 #include <linux/thermal.h>
 #include <linux/cpufreq.h>
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch
thermal-exynos-fix-build-error.patch
thermal-exynos-remove-duplicate-inclusion-of-errh-header-file.patch
thermal-exynos-use-devm_-functions.patch
drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch

