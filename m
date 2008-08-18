From: akpm@linux-foundation.org
Subject: + blackfin-rtc-driver-bf561-not-have-on-chip-rtc.patch added to -mm tree
Date: Mon, 18 Aug 2008 14:57:12 -0700
Message-ID: <200808182157.m7ILvCej014953@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753480AbYHRV5w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 17:57:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: graf.yang@analog.com, a.zummo@towertech.it, cooloney@kernel.org


The patch titled
     Blackfin RTC Driver: BF561 not have on-chip RTC
has been added to the -mm tree.  Its filename is
     blackfin-rtc-driver-bf561-not-have-on-chip-rtc.patch

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
Subject: Blackfin RTC Driver: BF561 not have on-chip RTC
From: Graf Yang <graf.yang@analog.com>

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/Kconfig~blackfin-rtc-driver-bf561-not-have-on-chip-rtc drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~blackfin-rtc-driver-bf561-not-have-on-chip-rtc
+++ a/drivers/rtc/Kconfig
@@ -561,7 +561,7 @@ config RTC_DRV_AT91SAM9_GPBR
 
 config RTC_DRV_BFIN
 	tristate "Blackfin On-Chip RTC"
-	depends on BLACKFIN
+	depends on BLACKFIN && !BF561
 	help
 	  If you say yes here you will get support for the
 	  Blackfin On-Chip Real Time Clock.
_

Patches currently in -mm which might be from graf.yang@analog.com are

blackfin-rtc-driver-bf561-not-have-on-chip-rtc.patch
linux-next.patch

