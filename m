From: akpm@linux-foundation.org
Subject: + rtc_class-is-no-longer-considered-experimental.patch added to -mm tree
Date: Tue, 19 Jun 2007 11:19:13 -0700
Message-ID: <200706191819.l5JIJDit017824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54177 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752569AbXFSSTZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jun 2007 14:19:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alessandro.zummo@towertech.it, a.zummo@towertech.it


The patch titled
     RTC_CLASS is no longer considered EXPERIMENTAL
has been added to the -mm tree.  Its filename is
     rtc_class-is-no-longer-considered-experimental.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: RTC_CLASS is no longer considered EXPERIMENTAL
From: Alessandro Zummo <alessandro.zummo@towertech.it>

RTC class is mature enough.

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    1 -
 1 files changed, 1 deletion(-)

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

rtc_class-is-no-longer-considered-experimental.patch
