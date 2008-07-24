From: akpm@linux-foundation.org
Subject: - rtc-m41t80-sort-header-inclusions-for-readability.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:29:55 -0700
Message-ID: <200807242329.m6ONTtgi011427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756497AbYGXXaW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:30:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, a.zummo@towertech.it, ab@mycable.de, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: m41t80: sort header inclusions for readability
has been removed from the -mm tree.  Its filename was
     rtc-m41t80-sort-header-inclusions-for-readability.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: m41t80: sort header inclusions for readability
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Sort the header inclusions for readability.  No functional changes.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexander Bigga <ab@mycable.de>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m41t80.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-m41t80.c~rtc-m41t80-sort-header-inclusions-for-readability drivers/rtc/rtc-m41t80.c
--- a/drivers/rtc/rtc-m41t80.c~rtc-m41t80-sort-header-inclusions-for-readability
+++ a/drivers/rtc/rtc-m41t80.c
@@ -13,21 +13,21 @@
  *
  */
 
-#include <linux/module.h>
+#include <linux/bcd.h>
+#include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/rtc.h>
 #include <linux/slab.h>
 #include <linux/smp_lock.h>
 #include <linux/string.h>
-#include <linux/i2c.h>
-#include <linux/rtc.h>
-#include <linux/bcd.h>
 #ifdef CONFIG_RTC_DRV_M41T80_WDT
-#include <linux/miscdevice.h>
-#include <linux/watchdog.h>
-#include <linux/reboot.h>
 #include <linux/fs.h>
 #include <linux/ioctl.h>
+#include <linux/miscdevice.h>
+#include <linux/reboot.h>
+#include <linux/watchdog.h>
 #endif
 
 #define M41T80_REG_SSEC	0
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
linux-next.patch
ntp-let-update_persistent_clock-sleep.patch
ntp-fix-calculation-of-the-next-jiffie-to-trigger-rtc-sync.patch

