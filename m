From: akpm@linux-foundation.org
Subject: + backlight-88pm860x_bl-remove-an-unnecessary-line-continuation.patch added to -mm tree
Date: Mon, 19 Nov 2012 14:22:13 -0800
Message-ID: <20121119222213.8FFC582004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:62499 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab2KSWWO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Nov 2012 17:22:14 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so614853yhl.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Nov 2012 14:22:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: backlight: 88pm860x_bl: remove an unnecessary line continuation
has been added to the -mm tree.  Its filename is
     backlight-88pm860x_bl-remove-an-unnecessary-line-continuation.patch

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
Subject: backlight: 88pm860x_bl: remove an unnecessary line continuation

Remove an unnecessary line continuation in pm860x_backlight_probe(). 
Also, a checkpatch warning is fixed as below:

WARNING: Avoid unnecessary line continuations

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/88pm860x_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/88pm860x_bl.c~backlight-88pm860x_bl-remove-an-unnecessary-line-continuation drivers/video/backlight/88pm860x_bl.c
--- a/drivers/video/backlight/88pm860x_bl.c~backlight-88pm860x_bl-remove-an-unnecessary-line-continuation
+++ a/drivers/video/backlight/88pm860x_bl.c
@@ -228,7 +228,7 @@ static int pm860x_backlight_probe(struct
 	sprintf(name, "backlight-%d", pdev->id);
 	data->port = pdev->id;
 	data->chip = chip;
-	data->i2c = (chip->id == CHIP_PM8606) ? chip->client	\
+	data->i2c = (chip->id == CHIP_PM8606) ? chip->client
 			: chip->companion;
 	data->current_brightness = MAX_BRIGHTNESS;
 	if (pm860x_backlight_dt_init(pdev, data, name)) {
_

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
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
backlight-lms283gf05-use-devm_gpio_request_one.patch
backlight-tosa-use-devm_gpio_request_one.patch
drivers-video-backlight-da9052_blc-add-missing-const.patch
drivers-video-backlight-lms283gf05c-add-missing-const.patch
drivers-video-backlight-tdo24mc-add-missing-const.patch
drivers-video-backlight-vgg2432a4c-add-missing-const.patch
drivers-video-backlight-s6e63m0c-remove-unnecessary-cast-of-void-pointer.patch
drivers-video-backlight-88pm860x_blc-drop-devm_kfree-of-devm_kzallocd-data.patch
drivers-video-backlight-max8925_blc-drop-devm_kfree-of-devm_kzallocd-data.patch
drivers-video-backlight-ep93xx_blc-fix-section-mismatch.patch
drivers-video-backlight-hp680_blc-add-missing-__devexit-macros-for-remove.patch
drivers-video-backlight-ili9320c-add-missing-__devexit-macros-for-remove.patch
backlight-add-of_find_backlight_by_node-function.patch
backlight-add-of_find_backlight_by_node-function-fix.patch
backlight-add-of_find_backlight_by_node-function-fix-2.patch
drivers-video-backlight-pandora_blc-change-twl4030_module_pwm0-to-twl_module_pwm.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix.patch

