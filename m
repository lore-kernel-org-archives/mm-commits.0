From: akpm@linux-foundation.org
Subject: + input-driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone-update.patch added to -mm tree
Date: Wed, 05 Mar 2008 14:51:36 -0800
Message-ID: <200803052251.m25MpbPd025407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765319AbYCEWzg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 17:55:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, dbaryshkov@gmail.com, gg@opensource.wolfsonmicro.com, giometti@enneenne.com, hcegtvedt@atmel.com, liam.girdwood@wolfsonmicro.com, linux01@architechnical.net, mike.arthur@wolfsonmicro.com, mkl@pengutronix.de, rmk@arm.linux.org.uk, spyro@f2s.com, stanley.cai@intel.com, vince@kyllikki.org, zap@homelink.ru


The patch titled
     Driver for WM97xx touchscreens in streaming mode on Mainstone (update)
has been added to the -mm tree.  Its filename is
     input-driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone-update.patch

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
Subject: Driver for WM97xx touchscreens in streaming mode on Mainstone (update)
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Signed-off-by: Liam Girdwood <liam.girdwood@wolfsonmicro.com>
Signed-off-by: Graeme Gregory <gg@opensource.wolfsonmicro.com>
Signed-off-by: Mike Arthur <mike.arthur@wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Stanley Cai <stanley.cai@intel.com>
Cc: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Pete MacKay <linux01@architechnical.net>
Cc: Ian Molton <spyro@f2s.com>
Cc: Vince Sanders <vince@kyllikki.org>
Cc: Andrew Zabolotny <zap@homelink.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/mainstone-wm97xx.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/input/touchscreen/mainstone-wm97xx.c~input-driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone-update drivers/input/touchscreen/mainstone-wm97xx.c
--- a/drivers/input/touchscreen/mainstone-wm97xx.c~input-driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone-update
+++ a/drivers/input/touchscreen/mainstone-wm97xx.c
@@ -257,6 +257,7 @@ static struct wm97xx_mach_ops mainstone_
 	.acc_startup = wm97xx_acc_startup,
 	.acc_shutdown = wm97xx_acc_shutdown,
 	.irq_enable = wm97xx_irq_enable,
+	.irq_gpio = WM97XX_GPIO_2,
 };
 
 static int mainstone_wm97xx_probe(struct platform_device *pdev)
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

git-alsa.patch
input-core-driver-for-wm97xx-touchscreens.patch
input-core-driver-for-wm97xx-touchscreens-update.patch
input-add-chip-driver-for-wm9705-touchscreen.patch
input-add-chip-driver-for-wm9712-touchscreen.patch
input-add-chip-driver-for-wm9713-touchscreen.patch
input-driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone.patch
input-driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone-update.patch
input-build-system-and-maintainers-entry-for-wm97xx-touchscreen-drivers.patch

