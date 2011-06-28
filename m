From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-ds1307c-add-support-for-rtc-device-pt7c4338.patch removed from -mm tree
Date: Tue, 28 Jun 2011 13:42:24 -0700
Message-ID: <201106282042.p5SKg6wv002968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708Ab1F1UmT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 16:42:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Priyanka.Jain@freescale.com, timur@freescale.com, w.sang@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/rtc-ds1307.c: add support for RTC device pt7c4338
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-ds1307c-add-support-for-rtc-device-pt7c4338.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


