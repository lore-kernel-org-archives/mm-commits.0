From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-da9052_blc-add-missing-const.patch added to -mm tree
Date: Tue, 23 Oct 2012 12:47:33 -0700
Message-ID: <20121023194734.91A395C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:41995 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875Ab2JWTrg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 15:47:36 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so256167eek.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 12:47:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, ashish.jangam@kpitcummins.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight/da9052_bl.c: add missing const
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-da9052_blc-add-missing-const.patch

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
Subject: drivers/video/backlight/da9052_bl.c: add missing const

Add 'const' to static array that was missing it in its definition.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/da9052_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/da9052_bl.c~drivers-video-backlight-da9052_blc-add-missing-const drivers/video/backlight/da9052_bl.c
--- a/drivers/video/backlight/da9052_bl.c~drivers-video-backlight-da9052_blc-add-missing-const
+++ a/drivers/video/backlight/da9052_bl.c
@@ -34,7 +34,7 @@ enum {
 	DA9052_TYPE_WLED3,
 };
 
-static unsigned char wled_bank[] = {
+static const unsigned char wled_bank[] = {
 	DA9052_LED1_CONF_REG,
 	DA9052_LED2_CONF_REG,
 	DA9052_LED3_CONF_REG,
_

Patches currently in -mm which might be from jg1.han@samsung.com are

backlight-ili9320-add-missing-spi-dependency.patch
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

