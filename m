From: akpm@linux-foundation.org
Subject: - driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-2.patch removed from -mm tree
Date: Mon, 09 Jul 2007 16:37:29 -0700
Message-ID: <200707092337.l69NbTLw020619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48940 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757829AbXGIXht (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 19:37:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hcegtvedt@atmel.com, a.zummo@towertech.it, david-b@pacbell.net, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices fix 2
has been removed from the -mm tree.  Its filename was
     driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-2.patch

This patch was dropped because it was folded into driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch

------------------------------------------------------
Subject: driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices fix 2
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>

rtc-at32ap700x driver updated to 2.6.22-rc4-mm2 kernel

Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at32ap700x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-at32ap700x.c~driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-2 drivers/rtc/rtc-at32ap700x.c
--- a/drivers/rtc/rtc-at32ap700x.c~driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-2
+++ a/drivers/rtc/rtc-at32ap700x.c
@@ -202,7 +202,7 @@ static irqreturn_t at32_rtc_interrupt(in
 				& ~RTC_BIT(CTRL_TOPEN));
 		rtc_writel(rtc, VAL, rtc->alarm_time);
 		events = RTC_AF | RTC_IRQF;
-		rtc_update_irq(&rtc->rtc->class_dev, 1, events);
+		rtc_update_irq(rtc->rtc, 1, events);
 		ret = IRQ_HANDLED;
 	}
 
_

Patches currently in -mm which might be from hcegtvedt@atmel.com are

git-avr32.patch
git-input.patch
git-watchdog.patch
rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported.patch
rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-2.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-3.patch
