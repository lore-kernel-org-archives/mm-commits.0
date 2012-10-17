From: akpm@linux-foundation.org
Subject: + backlight-da903x_bl-fix-checkpatch-warning.patch added to -mm tree
Date: Wed, 17 Oct 2012 16:13:35 -0700
Message-ID: <20121017231336.874AB20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:65172 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab2JQXNi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 19:13:38 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so491507wey.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 16:13:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: da903x_bl: fix checkpatch warning
has been added to the -mm tree.  Its filename is
     backlight-da903x_bl-fix-checkpatch-warning.patch

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
Subject: backlight: da903x_bl: fix checkpatch warning

This patch fixes the checkpatch warning as below:

WARNING: please, no space before tabs
WARNING: quoted string split across lines

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/da903x_bl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/da903x_bl.c~backlight-da903x_bl-fix-checkpatch-warning drivers/video/backlight/da903x_bl.c
--- a/drivers/video/backlight/da903x_bl.c~backlight-da903x_bl-fix-checkpatch-warning
+++ a/drivers/video/backlight/da903x_bl.c
@@ -2,10 +2,10 @@
  * Backlight driver for Dialog Semiconductor DA9030/DA9034
  *
  * Copyright (C) 2008 Compulab, Ltd.
- * 	Mike Rapoport <mike@compulab.co.il>
+ *	Mike Rapoport <mike@compulab.co.il>
  *
  * Copyright (C) 2006-2008 Marvell International Ltd.
- * 	Eric Miao <eric.miao@marvell.com>
+ *	Eric Miao <eric.miao@marvell.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -198,7 +198,7 @@ static struct platform_driver da903x_bac
 module_platform_driver(da903x_backlight_driver);
 
 MODULE_DESCRIPTION("Backlight Driver for Dialog Semiconductor DA9030/DA9034");
-MODULE_AUTHOR("Eric Miao <eric.miao@marvell.com>"
-	      "Mike Rapoport <mike@compulab.co.il>");
+MODULE_AUTHOR("Eric Miao <eric.miao@marvell.com>");
+MODULE_AUTHOR("Mike Rapoport <mike@compulab.co.il>");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:da903x-backlight");
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

