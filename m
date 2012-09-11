From: akpm@linux-foundation.org
Subject: [merged] thermal-exynos-remove-duplicate-inclusion-of-errh-header-file.patch removed from -mm tree
Date: Tue, 11 Sep 2012 12:33:02 -0700
Message-ID: <20120911193302.AB5B11E004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:40773 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab2IKTdD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Sep 2012 15:33:03 -0400
Received: by qcqs25 with SMTP id s25so96181qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Sep 2012 12:33:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, guenter.roeck@ericsson.com, len.brown@intel.com, lenb@kernel.org, sachin.kamat@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/thermal/exynos_thermal.c: remove duplicate inclusion of err.h header file
has been removed from the -mm tree.  Its filename was
     thermal-exynos-remove-duplicate-inclusion-of-errh-header-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch

