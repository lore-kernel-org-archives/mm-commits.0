From: akpm@linux-foundation.org
Subject: + backlight-hp680_bl-fix-checkpatch-error-and-warning.patch added to -mm tree
Date: Wed, 17 Oct 2012 16:13:42 -0700
Message-ID: <20121017231343.AF60B5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:61616 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab2JQXNp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 19:13:45 -0400
Received: by mail-ea0-f202.google.com with SMTP id q10so321981eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 16:13:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: hp680_bl: fix checkpatch error and warning
has been added to the -mm tree.  Its filename is
     backlight-hp680_bl-fix-checkpatch-error-and-warning.patch

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
Subject: backlight: hp680_bl: fix checkpatch error and warning

This patch fixes the checkpatch error and warning as below:

WARNING: please, no space before tabs
WARNING: please, no spaces at the start of a line
ERROR: do not initialise statics to 0 or NULL
ERROR: code indent should use tabs where possible

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/hp680_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/hp680_bl.c~backlight-hp680_bl-fix-checkpatch-error-and-warning drivers/video/backlight/hp680_bl.c
--- a/drivers/video/backlight/hp680_bl.c~backlight-hp680_bl-fix-checkpatch-error-and-warning
+++ a/drivers/video/backlight/hp680_bl.c
@@ -26,7 +26,7 @@
 #define HP680_DEFAULT_INTENSITY 10
 
 static int hp680bl_suspended;
-static int current_intensity = 0;
+static int current_intensity;
 static DEFINE_SPINLOCK(bl_lock);
 
 static void hp680bl_send_intensity(struct backlight_device *bd)
@@ -168,7 +168,7 @@ static int __init hp680bl_init(void)
 static void __exit hp680bl_exit(void)
 {
 	platform_device_unregister(hp680bl_device);
- 	platform_driver_unregister(&hp680bl_driver);
+	platform_driver_unregister(&hp680bl_driver);
 }
 
 module_init(hp680bl_init);
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

