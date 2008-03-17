From: akpm@linux-foundation.org
Subject: + rtc-fix-kconfig-help.patch added to -mm tree
Date: Mon, 17 Mar 2008 16:39:48 -0700
Message-ID: <200803172339.m2HNdmaZ004188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752043AbYCQXka (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 19:40:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alessandro.zummo@towertech.it, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc: fix kconfig help
has been added to the -mm tree.  Its filename is
     rtc-fix-kconfig-help.patch

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
Subject: rtc: fix kconfig help
From: Alessandro Zummo <alessandro.zummo@towertech.it>

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/Kconfig~rtc-fix-kconfig-help drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-fix-kconfig-help
+++ a/drivers/rtc/Kconfig
@@ -16,7 +16,7 @@ menuconfig RTC_CLASS
 	  probably want to enable one or more of the interfaces below.
 
 	  This driver can also be built as a module. If so, the module
-	  will be called rtc-class.
+	  will be called rtc-core.
 
 if RTC_CLASS
 
_

Patches currently in -mm which might be from alessandro.zummo@towertech.it are

rtc-fix-kconfig-help.patch

