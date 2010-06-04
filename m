From: akpm@linux-foundation.org
Subject: + rtc-rtc-mxc-remove-six-unused-fields.patch added to -mm tree
Date: Fri, 04 Jun 2010 16:13:31 -0700
Message-ID: <201006042313.o54NDVXF023889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757395Ab0FDXNq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 19:13:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcuos.com@gmail.com, a.zummo@towertech.it, p_gortmaker@yahoo.com


The patch titled
     rtc/rtc-mxc: remove six unused fields
has been added to the -mm tree.  Its filename is
     rtc-rtc-mxc-remove-six-unused-fields.patch

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
Subject: rtc/rtc-mxc: remove six unused fields
From: Wan ZongShun <mcuos.com@gmail.com>

Remove six unused fields from `struct rtc_plat_data'.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mxc.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/rtc/rtc-mxc.c~rtc-rtc-mxc-remove-six-unused-fields drivers/rtc/rtc-mxc.c
--- a/drivers/rtc/rtc-mxc.c~rtc-rtc-mxc-remove-six-unused-fields
+++ a/drivers/rtc/rtc-mxc.c
@@ -83,12 +83,6 @@ struct rtc_plat_data {
 	void __iomem *ioaddr;
 	int irq;
 	struct clk *clk;
-	unsigned int irqen;
-	int alrm_sec;
-	int alrm_min;
-	int alrm_hour;
-	int alrm_mday;
-	struct timespec mxc_rtc_delta;
 	struct rtc_time g_rtc_alarm;
 };
 
_

Patches currently in -mm which might be from mcuos.com@gmail.com are

linux-next.patch
nuc900-rtc-change-the-waiting-for-device-ready-implement.patch
drivers-rtc-rtc-pcf8563c-remove-unused-struct.patch
rtc-pxa-remove-unused-field.patch
rtc-m48t59-kfreenull-is-ok.patch
rtc-rtc-mxc-remove-six-unused-fields.patch

