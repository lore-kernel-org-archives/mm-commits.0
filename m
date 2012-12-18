From: akpm@linux-foundation.org
Subject: [merged] backlight-corgi_lcd-fix-checkpatch-error-and-warning.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:04:00 -0800
Message-ID: <20121218200400.B48E482004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:46105 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUEE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:04:04 -0500
Received: by mail-qc0-f201.google.com with SMTP id a6so125310qch.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:04:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: corgi_lcd: fix checkpatch error and warning
has been removed from the -mm tree.  Its filename was
     backlight-corgi_lcd-fix-checkpatch-error-and-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: corgi_lcd: fix checkpatch error and warning

This patch fixes the checkpatch error and warning as below:

WARNING: please, no space before tabs
WARNING: quoted string split across lines
ERROR: space required before the open parenthesis '('

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/corgi_lcd.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/video/backlight/corgi_lcd.c~backlight-corgi_lcd-fix-checkpatch-error-and-warning drivers/video/backlight/corgi_lcd.c
--- a/drivers/video/backlight/corgi_lcd.c~backlight-corgi_lcd-fix-checkpatch-error-and-warning
+++ a/drivers/video/backlight/corgi_lcd.c
@@ -6,8 +6,8 @@
  *  Based on Sharp's 2.4 Backlight Driver
  *
  *  Copyright (c) 2008 Marvell International Ltd.
- *  	Converted to SPI device based LCD/Backlight device driver
- *  	by Eric Miao <eric.miao@marvell.com>
+ *	Converted to SPI device based LCD/Backlight device driver
+ *	by Eric Miao <eric.miao@marvell.com>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License version 2 as
@@ -192,7 +192,7 @@ static void lcdtg_set_phadadj(struct cor
 {
 	int adj;
 
-	switch(mode) {
+	switch (mode) {
 	case CORGI_LCD_MODE_VGA:
 		/* Setting for VGA */
 		adj = sharpsl_param.phadadj;
@@ -495,8 +495,9 @@ static int setup_gpio_backlight(struct c
 		err = devm_gpio_request(&spi->dev, pdata->gpio_backlight_on,
 					"BL_ON");
 		if (err) {
-			dev_err(&spi->dev, "failed to request GPIO%d for "
-				"backlight_on\n", pdata->gpio_backlight_on);
+			dev_err(&spi->dev,
+				"failed to request GPIO%d for backlight_on\n",
+				pdata->gpio_backlight_on);
 			return err;
 		}
 
@@ -508,8 +509,9 @@ static int setup_gpio_backlight(struct c
 		err = devm_gpio_request(&spi->dev, pdata->gpio_backlight_cont,
 					"BL_CONT");
 		if (err) {
-			dev_err(&spi->dev, "failed to request GPIO%d for "
-				"backlight_cont\n", pdata->gpio_backlight_cont);
+			dev_err(&spi->dev,
+				"failed to request GPIO%d for backlight_cont\n",
+				pdata->gpio_backlight_cont);
 			return err;
 		}
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch

