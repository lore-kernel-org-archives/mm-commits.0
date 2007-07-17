From: akpm@linux-foundation.org
Subject: - rtc_class-is-no-longer-considered-experimental.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:05:39 -0700
Message-ID: <200707172305.l6HN5dNM011939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44549 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934712AbXGQXPT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alessandro.zummo@towertech.it, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     RTC_CLASS is no longer considered EXPERIMENTAL
has been removed from the -mm tree.  Its filename was
     rtc_class-is-no-longer-considered-experimental.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: RTC_CLASS is no longer considered EXPERIMENTAL
From: Alessandro Zummo <alessandro.zummo@towertech.it>

RTC class is mature enough.

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/rtc/Kconfig~rtc_class-is-no-longer-considered-experimental drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc_class-is-no-longer-considered-experimental
+++ a/drivers/rtc/Kconfig
@@ -10,7 +10,6 @@ config RTC_LIB
 
 config RTC_CLASS
 	tristate "RTC class"
-	depends on EXPERIMENTAL
 	default n
 	select RTC_LIB
 	help
_

Patches currently in -mm which might be from alessandro.zummo@towertech.it are

origin.patch
