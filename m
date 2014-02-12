From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-isl12057c-remove-duplicate-include.patch added
 to -mm tree
Date: Wed, 12 Feb 2014 14:17:39 -0800
Message-ID: <52fbf303.lDLGqAWhbDozzKPc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbaBLWRj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Feb 2014 17:17:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sachin.kamat@linaro.org

Subject: + drivers-rtc-rtc-isl12057c-remove-duplicate-include.patch added to -mm tree
To: sachin.kamat@linaro.org
From: akpm@linux-foundation.org
Date: Wed, 12 Feb 2014 14:17:39 -0800


The patch titled
     Subject: drivers/rtc/rtc-isl12057.c: remove duplicate include
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-isl12057c-remove-duplicate-include.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-isl12057c-remove-duplicate-include.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-isl12057c-remove-duplicate-include.patch

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
Subject: drivers/rtc/rtc-isl12057.c: remove duplicate include

linux/rtc.h was included twice.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl12057.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/rtc/rtc-isl12057.c~drivers-rtc-rtc-isl12057c-remove-duplicate-include drivers/rtc/rtc-isl12057.c
--- a/drivers/rtc/rtc-isl12057.c~drivers-rtc-rtc-isl12057c-remove-duplicate-include
+++ a/drivers/rtc/rtc-isl12057.c
@@ -26,7 +26,6 @@
 #include <linux/rtc.h>
 #include <linux/i2c.h>
 #include <linux/bcd.h>
-#include <linux/rtc.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/regmap.h>
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
drivers-rtc-rtc-isl12057c-remove-duplicate-include.patch
linux-next.patch

