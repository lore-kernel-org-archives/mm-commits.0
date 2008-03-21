From: akpm@linux-foundation.org
Subject: - rtc-fix-kconfig-help.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:29:29 -0700
Message-ID: <200803212029.m2LKTTcR008877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755296AbYCUU3q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:29:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alessandro.zummo@towertech.it, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: fix kconfig help
has been removed from the -mm tree.  Its filename was
     rtc-fix-kconfig-help.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

