From: akpm@linux-foundation.org
Subject: + rtc-pxa-remove-unused-field.patch added to -mm tree
Date: Fri, 04 Jun 2010 16:13:26 -0700
Message-ID: <201006042313.o54NDQBu023883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757395Ab0FDXNr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 19:13:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcuos.com@gmail.com, a.zummo@towertech.it, eric.y.miao@gmail.com


The patch titled
     rtc/pxa: remove unused field
has been added to the -mm tree.  Its filename is
     rtc-pxa-remove-unused-field.patch

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
Subject: rtc/pxa: remove unused field
From: Wan ZongShun <mcuos.com@gmail.com>

pxa_rtc.rtc_alarm is unused.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pxa.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/rtc/rtc-pxa.c~rtc-pxa-remove-unused-field drivers/rtc/rtc-pxa.c
--- a/drivers/rtc/rtc-pxa.c~rtc-pxa-remove-unused-field
+++ a/drivers/rtc/rtc-pxa.c
@@ -87,7 +87,6 @@ struct pxa_rtc {
 	int			irq_Alrm;
 	struct rtc_device	*rtc;
 	spinlock_t		lock;		/* Protects this structure */
-	struct rtc_time		rtc_alarm;
 };
 
 static u32 ryxr_calc(struct rtc_time *tm)
_

Patches currently in -mm which might be from mcuos.com@gmail.com are

linux-next.patch
nuc900-rtc-change-the-waiting-for-device-ready-implement.patch
drivers-rtc-rtc-pcf8563c-remove-unused-struct.patch
rtc-pxa-remove-unused-field.patch
rtc-m48t59-kfreenull-is-ok.patch
rtc-rtc-mxc-remove-six-unused-fields.patch

