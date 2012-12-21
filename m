From: akpm@linux-foundation.org
Subject: [merged] rtc-imx-dryice-must-include-linux-spinlockh.patch removed from -mm tree
Date: Fri, 21 Dec 2012 12:39:31 -0800
Message-ID: <20121221203931.9AD8882004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:33608 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab2LUUjc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 15:39:32 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so205420ghb.3
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 12:39:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, s.hauer@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-imxdi.c: must include <linux/spinlock.h>
has been removed from the -mm tree.  Its filename was
     rtc-imx-dryice-must-include-linux-spinlockh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jean Delvare <khali@linux-fr.org>
Subject: drivers/rtc/rtc-imxdi.c: must include <linux/spinlock.h>

Add the missing header include for spinlocks, to avoid potential build
failures on specific architectures or configurations.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-imxdi.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-imxdi.c~rtc-imx-dryice-must-include-linux-spinlockh drivers/rtc/rtc-imxdi.c
--- a/drivers/rtc/rtc-imxdi.c~rtc-imx-dryice-must-include-linux-spinlockh
+++ a/drivers/rtc/rtc-imxdi.c
@@ -36,6 +36,7 @@
 #include <linux/platform_device.h>
 #include <linux/rtc.h>
 #include <linux/sched.h>
+#include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/of.h>
 
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
linux-next.patch

