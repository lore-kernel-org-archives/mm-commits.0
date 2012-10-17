From: akpm@linux-foundation.org
Subject: + backlight-pcf50633-fix-checkpatch-warning.patch added to -mm tree
Date: Wed, 17 Oct 2012 16:14:05 -0700
Message-ID: <20121017231406.A725E5C0065@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:65057 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab2JQXOJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 19:14:09 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so491795eek.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 16:14:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: pcf50633: fix checkpatch warning
has been added to the -mm tree.  Its filename is
     backlight-pcf50633-fix-checkpatch-warning.patch

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
Subject: backlight: pcf50633: fix checkpatch warning

This patch fixes the checkpatch warning as below:

WARNING: please, no spaces at the start of a line

Also, long comments are fixed for the preferred style.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/pcf50633-backlight.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/video/backlight/pcf50633-backlight.c~backlight-pcf50633-fix-checkpatch-warning drivers/video/backlight/pcf50633-backlight.c
--- a/drivers/video/backlight/pcf50633-backlight.c~backlight-pcf50633-fix-checkpatch-warning
+++ a/drivers/video/backlight/pcf50633-backlight.c
@@ -52,7 +52,7 @@ int pcf50633_bl_set_brightness_limit(str
 	pcf_bl->brightness_limit = limit & 0x3f;
 	backlight_update_status(pcf_bl->bl);
 
-    return 0;
+	return 0;
 }
 
 static int pcf50633_bl_update_status(struct backlight_device *bl)
@@ -136,8 +136,10 @@ static int __devinit pcf50633_bl_probe(s
 
 	pcf50633_reg_write(pcf_bl->pcf, PCF50633_REG_LEDDIM, pdata->ramp_time);
 
-	/* Should be different from bl_props.brightness, so we do not exit
-	 * update_status early the first time it's called */
+	/*
+	 * Should be different from bl_props.brightness, so we do not exit
+	 * update_status early the first time it's called
+	 */
 	pcf_bl->brightness = pcf_bl->bl->props.brightness + 1;
 
 	backlight_update_status(pcf_bl->bl);
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

