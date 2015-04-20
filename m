From: akpm@linux-foundation.org
Subject: [merged] rtc-hctosys-use-function-name-in-the-error-log.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:18:10 -0700
Message-ID: <553550f2.D90ZrWbgQmxf1skw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551AbbDTTLt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:11:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aaro.koskinen@iki.fi, a.zummo@towertech.it, alexandre.belloni@free-electrons.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: hctosys: use function name in the error log
has been removed from the -mm tree.  Its filename was
     rtc-hctosys-use-function-name-in-the-error-log.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: rtc: hctosys: use function name in the error log

Use function name in the error log instead of __FILE__.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/hctosys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/hctosys.c~rtc-hctosys-use-function-name-in-the-error-log drivers/rtc/hctosys.c
--- a/drivers/rtc/hctosys.c~rtc-hctosys-use-function-name-in-the-error-log
+++ a/drivers/rtc/hctosys.c
@@ -33,7 +33,7 @@ static int __init rtc_hctosys(void)
 
 	if (rtc == NULL) {
 		pr_info("%s: unable to open rtc device (%s)\n",
-			__FILE__, CONFIG_RTC_HCTOSYS_DEVICE);
+			__func__, CONFIG_RTC_HCTOSYS_DEVICE);
 		goto err_open;
 	}
 
_

Patches currently in -mm which might be from aaro.koskinen@iki.fi are

origin.patch
linux-next.patch

