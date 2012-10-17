From: akpm@linux-foundation.org
Subject: + backlight-generic_bl-fix-checkpatch-warning.patch added to -mm tree
Date: Wed, 17 Oct 2012 16:13:38 -0700
Message-ID: <20121017231339.9A2425C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:50011 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab2JQXNm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 19:13:42 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so487191fae.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 16:13:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: generic_bl: fix checkpatch warning
has been added to the -mm tree.  Its filename is
     backlight-generic_bl-fix-checkpatch-warning.patch

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
Subject: backlight: generic_bl: fix checkpatch warning

This patch fixes the checkpatch warning as below:

WARNING: space prohibited between function name and open parenthesis '('

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/generic_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/generic_bl.c~backlight-generic_bl-fix-checkpatch-warning drivers/video/backlight/generic_bl.c
--- a/drivers/video/backlight/generic_bl.c~backlight-generic_bl-fix-checkpatch-warning
+++ a/drivers/video/backlight/generic_bl.c
@@ -97,8 +97,8 @@ static int genericbl_probe(struct platfo
 	props.max_brightness = machinfo->max_intensity;
 	bd = backlight_device_register(name, &pdev->dev, NULL, &genericbl_ops,
 				       &props);
-	if (IS_ERR (bd))
-		return PTR_ERR (bd);
+	if (IS_ERR(bd))
+		return PTR_ERR(bd);
 
 	platform_set_drvdata(pdev, bd);
 
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

