From: akpm@linux-foundation.org
Subject: + rtc-imx-dryice-must-include-linux-spinlockh.patch added to -mm tree
Date: Tue, 18 Dec 2012 16:35:11 -0800
Message-ID: <20121219003512.052EA20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f73.google.com ([74.125.82.73]:63711 "EHLO
	mail-wg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab2LSAfO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 19:35:14 -0500
Received: by mail-wg0-f73.google.com with SMTP id dt12so71534wgb.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 16:35:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, s.hauer@pengutronix.de


The patch titled
     Subject: drivers/rtc/rtc-imxdi.c: must include <linux/spinlock.h>
has been added to the -mm tree.  Its filename is
     rtc-imx-dryice-must-include-linux-spinlockh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists.patch
rtc-imx-dryice-must-include-linux-spinlockh.patch

