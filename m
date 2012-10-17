From: akpm@linux-foundation.org
Subject: + backlight-l4f00242t03-fix-checkpatch-warning.patch added to -mm tree
Date: Wed, 17 Oct 2012 16:13:52 -0700
Message-ID: <20121017231353.23481100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:32778 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab2JQXNy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 19:13:54 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so913993vbi.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 16:13:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: l4f00242t03: fix checkpatch warning
has been added to the -mm tree.  Its filename is
     backlight-l4f00242t03-fix-checkpatch-warning.patch

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
Subject: backlight: l4f00242t03: fix checkpatch warning

This patch fixes the checkpatch warning as below:

WARNING: please, no space before tabs

Also, unnecessary line is removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/l4f00242t03.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/video/backlight/l4f00242t03.c~backlight-l4f00242t03-fix-checkpatch-warning drivers/video/backlight/l4f00242t03.c
--- a/drivers/video/backlight/l4f00242t03.c~backlight-l4f00242t03-fix-checkpatch-warning
+++ a/drivers/video/backlight/l4f00242t03.c
@@ -4,7 +4,7 @@
  * Copyright 2007-2009 Freescale Semiconductor, Inc. All Rights Reserved.
  *
  * Copyright (c) 2009 Alberto Panizzo <maramaopercheseimorto@gmail.com>
- * 	Inspired by Marek Vasut work in l4f00242t03.c
+ *	Inspired by Marek Vasut work in l4f00242t03.c
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -33,7 +33,6 @@ struct l4f00242t03_priv {
 	struct regulator *core_reg;
 };
 
-
 static void l4f00242t03_reset(unsigned int gpio)
 {
 	pr_debug("l4f00242t03_reset.\n");
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

