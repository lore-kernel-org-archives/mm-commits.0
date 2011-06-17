From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-ds1307c-add-support-for-rtc-device-pt7c4338.patch added to -mm tree
Date: Fri, 17 Jun 2011 15:03:16 -0700
Message-ID: <201106172203.p5HM3G2G003752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757775Ab1FQWD0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jun 2011 18:03:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Priyanka.Jain@freescale.com, timur@freescale.com, w.sang@pengutronix.de


The patch titled
     drivers/rtc/rtc-ds1307.c: add support for RTC device pt7c4338
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ds1307c-add-support-for-rtc-device-pt7c4338.patch

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
Subject: drivers/rtc/rtc-ds1307.c: add support for RTC device pt7c4338
From: Priyanka Jain <Priyanka.Jain@freescale.com>

PT7C4338 chip is being manufactured by Pericom Technology Inc.  It is a
serial real-time clock which provides:

1) Low-power clock/calendar.
2) Programmable square-wave output.

It has 56 bytes of nonvolatile RAM.  Its register set is same as that of
rtc device: DS1307.

Signed-off-by: Priyanka Jain <Priyanka.Jain@freescale.com>
Acked-by: Timur Tabi <timur@freescale.com>
Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-ds1307.c~drivers-rtc-rtc-ds1307c-add-support-for-rtc-device-pt7c4338 drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~drivers-rtc-rtc-ds1307c-add-support-for-rtc-device-pt7c4338
+++ a/drivers/rtc/rtc-ds1307.c
@@ -149,6 +149,7 @@ static const struct i2c_device_id ds1307
 	{ "ds1340", ds_1340 },
 	{ "ds3231", ds_3231 },
 	{ "m41t00", m41t00 },
+	{ "pt7c4338", ds_1307 },
 	{ "rx8025", rx_8025 },
 	{ }
 };
_

Patches currently in -mm which might be from Priyanka.Jain@freescale.com are

drivers-rtc-rtc-ds1307c-add-support-for-rtc-device-pt7c4338.patch

