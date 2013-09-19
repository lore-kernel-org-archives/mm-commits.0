From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-vr41xxc-fix-checkpatch-warnings.patch added to
 -mm tree
Date: Thu, 19 Sep 2013 15:10:18 -0700
Message-ID: <523b764a.zz+Zc4gGSs5lJzol%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3ISWKT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 18:10:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yuasa@linux-mips.org, jg1.han@samsung.com, sachin.kamat@linaro.org

Subject: + drivers-rtc-rtc-vr41xxc-fix-checkpatch-warnings.patch added to -mm tree
To: sachin.kamat@linaro.org,jg1.han@samsung.com,yuasa@linux-mips.org
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 15:10:18 -0700


The patch titled
     Subject: drivers/rtc/rtc-vr41xx.c: fix checkpatch warnings
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-vr41xxc-fix-checkpatch-warnings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-vr41xxc-fix-checkpatch-warnings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-vr41xxc-fix-checkpatch-warnings.patch

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
Subject: drivers/rtc/rtc-vr41xx.c: fix checkpatch warnings

Fixes the following warnings:
WARNING: Use #include <linux/io.h> instead of <asm/io.h>
WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Yoichi Yuasa <yuasa@linux-mips.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-vr41xx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-vr41xx.c~drivers-rtc-rtc-vr41xxc-fix-checkpatch-warnings drivers/rtc/rtc-vr41xx.c
--- a/drivers/rtc/rtc-vr41xx.c~drivers-rtc-rtc-vr41xxc-fix-checkpatch-warnings
+++ a/drivers/rtc/rtc-vr41xx.c
@@ -20,6 +20,7 @@
 #include <linux/err.h>
 #include <linux/fs.h>
 #include <linux/init.h>
+#include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
@@ -27,11 +28,10 @@
 #include <linux/rtc.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
+#include <linux/uaccess.h>
 #include <linux/log2.h>
 
 #include <asm/div64.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
 
 MODULE_AUTHOR("Yoichi Yuasa <yuasa@linux-mips.org>");
 MODULE_DESCRIPTION("NEC VR4100 series RTC driver");
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

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
linux-next.patch

