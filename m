From: akpm@linux-foundation.org
Subject: + rtc-m41t80-include-linux-kernelh-for-printk.patch added to -mm tree
Date: Fri, 09 May 2008 19:05:27 -0700
Message-ID: <200805100205.m4A25R4c003721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751185AbYEJCGK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 22:06:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, a.zummo@towertech.it, ab@mycable.de, david-b@pacbell.net, wim@iguana.be


The patch titled
     rtc: m41t80: include <linux/kernel.h> for printk()
has been added to the -mm tree.  Its filename is
     rtc-m41t80-include-linux-kernelh-for-printk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

rtc-rtc_time_to_tm-use-unsigned-arithmetic.patch
rtc-rtc_time_to_tm-use-unsigned-arithmetic-fix.patch
rtc-watchdog-m41t80-fix-a-potential-use-of-unitialized-data.patch
rtc-m41t80-include-linux-kernelh-for-printk.patch
linux-next.patch

