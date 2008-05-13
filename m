From: akpm@linux-foundation.org
Subject: - rtc-m41t80-include-linux-kernelh-for-printk.patch removed from -mm tree
Date: Tue, 13 May 2008 14:34:23 -0700
Message-ID: <200805132134.m4DLYNuI000915@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760466AbYEMVeu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:34:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, a.zummo@towertech.it, ab@mycable.de, david-b@pacbell.net, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     rtc: m41t80: include <linux/kernel.h> for printk()
has been removed from the -mm tree.  Its filename was
     rtc-m41t80-include-linux-kernelh-for-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: m41t80: include <linux/kernel.h> for printk()
From: "Maciej W. Rozycki" <macro@linux-mips.org>

The driver uses printk(), but does not include <linux/kernel.h> -- add it.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexander Bigga <ab@mycable.de>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m41t80.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-m41t80.c~rtc-m41t80-include-linux-kernelh-for-printk drivers/rtc/rtc-m41t80.c
--- a/drivers/rtc/rtc-m41t80.c~rtc-m41t80-include-linux-kernelh-for-printk
+++ a/drivers/rtc/rtc-m41t80.c
@@ -15,6 +15,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/i2c.h>
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
linux-next.patch
ntp-make-the-rtc-sync-mode-11-minute-again.patch
ntp-fix-calculation-of-the-next-jiffie-to-trigger-rtc-sync.patch
rtc-m41t80-sort-header-inclusions-for-readability.patch
rtc-m41t80-use-pr_info-as-appropriate.patch

