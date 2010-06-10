From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-pl031c-remove-unused-include-linux-versionh.patch added to -mm tree
Date: Thu, 10 Jun 2010 13:51:29 -0700
Message-ID: <201006102051.o5AKpTQt023033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752094Ab0FJUvj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jun 2010 16:51:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: weiyi.huang@gmail.com, a.zummo@towertech.it, mcuos.com@gmail.com


The patch titled
     drivers/rtc/rtc-pl031.c: remove unused #include <linux/version.h>
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pl031c-remove-unused-include-linux-versionh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-pl031.c: remove unused #include <linux/version.h>
From: Huang Weiyi <weiyi.huang@gmail.com>

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Acked-by: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pl031.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/rtc/rtc-pl031.c~drivers-rtc-rtc-pl031c-remove-unused-include-linux-versionh drivers/rtc/rtc-pl031.c
--- a/drivers/rtc/rtc-pl031.c~drivers-rtc-rtc-pl031c-remove-unused-include-linux-versionh
+++ a/drivers/rtc/rtc-pl031.c
@@ -23,7 +23,6 @@
 #include <linux/io.h>
 #include <linux/bcd.h>
 #include <linux/delay.h>
-#include <linux/version.h>
 #include <linux/slab.h>
 
 /*
_

Patches currently in -mm which might be from weiyi.huang@gmail.com are

linux-next.patch
drivers-rtc-rtc-pl031c-remove-unused-include-linux-versionh.patch

