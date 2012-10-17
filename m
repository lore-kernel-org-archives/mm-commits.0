From: akpm@linux-foundation.org
Subject: + backlight-corgi_lcd-fix-checkpatch-error-and-warning.patch added to -mm tree
Date: Wed, 17 Oct 2012 16:13:31 -0700
Message-ID: <20121017231332.A412720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:65172 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab2JQXNf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 19:13:35 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so491507wey.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 16:13:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: corgi_lcd: fix checkpatch error and warning
has been added to the -mm tree.  Its filename is
     backlight-corgi_lcd-fix-checkpatch-error-and-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

backlight-da903x_bl-use-dev_get_drvdata-instead-of-platform_get_drvdata.patch
backlight-88pm860x_bl-fix-checkpatch-warning.patch
backlight-atmel-pwm-bl-fix-checkpatch-warning.patch
backlight-corgi_lcd-fix-checkpatch-error-and-warning.patch
backlight-da903x_bl-fix-checkpatch-warning.patch
backlight-generic_bl-fix-checkpatch-warning.patch
backlight-hp680_bl-fix-checkpatch-error-and-warning.patch
backlight-ili9320-fix-checkpatch-error-and-warning.patch
backlight-jornada720-fix-checkpatch-error-and-warning.patch
backlight-l4f00242t03-fix-checkpatch-warning.patch
backlight-lm3630-fix-checkpatch-warning.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch
backlight-omap1-fix-checkpatch-warning.patch
backlight-pcf50633-fix-checkpatch-warning.patch
backlight-platform_lcd-fix-checkpatch-error.patch
backlight-tdo24m-fix-checkpatch-warning.patch
backlight-tosa-fix-checkpatch-error-and-warning.patch
backlight-vgg2432a4-fix-checkpatch-warning.patch

