From: akpm@linux-foundation.org
Subject: - blackfin-rtc-driver-bf561-not-have-on-chip-rtc.patch removed from -mm tree
Date: Wed, 20 Aug 2008 20:49:08 -0700
Message-ID: <200808210349.m7L3n8Km015614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754328AbYHUDt1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 23:49:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: graf.yang@analog.com, a.zummo@towertech.it, cooloney@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Blackfin RTC Driver: BF561 not have on-chip RTC
has been removed from the -mm tree.  Its filename was
     blackfin-rtc-driver-bf561-not-have-on-chip-rtc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

