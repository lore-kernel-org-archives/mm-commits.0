From: akpm@linux-foundation.org
Subject: - input-driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone-update.patch removed from -mm tree
Date: Mon, 10 Mar 2008 03:07:02 -0700
Message-ID: <200803101007.m2AA72In011193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33588 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751368AbYCJKJL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 06:09:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, dbaryshkov@gmail.com, gg@opensource.wolfsonmicro.com, giometti@enneenne.com, hcegtvedt@atmel.com, liam.girdwood@wolfsonmicro.com, linux01@architec


The patch titled
     Driver for WM97xx touchscreens in streaming mode on Mainstone (update)
has been removed from the -mm tree.  Its filename was
     input-driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone-update.patch

This patch was dropped because it was folded into input-driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone.patch

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
git-arm.patch
input-core-driver-for-wm97xx-touchscreens.patch
input-add-chip-driver-for-wm9705-touchscreen.patch
input-add-chip-driver-for-wm9712-touchscreen.patch
input-add-chip-driver-for-wm9713-touchscreen.patch
input-driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone.patch
input-driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone-update.patch
input-build-system-and-maintainers-entry-for-wm97xx-touchscreen-drivers.patch
regulator-consumer-interface.patch
regulator-consumer-interface-fix.patch
regulator-regulator-driver-interface.patch
regulator-regulator-driver-interface-fix.patch
regulator-platform-interface.patch
regulator-framework-core.patch
regulator-framework-core-fix.patch
regulator-sysfs-abi.patch
regulator-kbuild.patch
regulator-maintainers.patch

