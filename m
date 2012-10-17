From: akpm@linux-foundation.org
Subject: + backlight-tdo24m-fix-checkpatch-warning.patch added to -mm tree
Date: Wed, 17 Oct 2012 16:14:11 -0700
Message-ID: <20121017231412.8B89C5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:45428 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab2JQXOO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 19:14:14 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so487201fae.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 16:14:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: tdo24m: fix checkpatch warning
has been added to the -mm tree.  Its filename is
     backlight-tdo24m-fix-checkpatch-warning.patch

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
Subject: backlight: tdo24m: fix checkpatch warning

This patch fixes the checkpatch warning as below:

WARNING: please, no space before tabs

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/tdo24m.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/backlight/tdo24m.c~backlight-tdo24m-fix-checkpatch-warning drivers/video/backlight/tdo24m.c
--- a/drivers/video/backlight/tdo24m.c~backlight-tdo24m-fix-checkpatch-warning
+++ a/drivers/video/backlight/tdo24m.c
@@ -2,7 +2,7 @@
  * tdo24m - SPI-based drivers for Toppoly TDO24M series LCD panels
  *
  * Copyright (C) 2008 Marvell International Ltd.
- * 	Eric Miao <eric.miao@marvell.com>
+ *	Eric Miao <eric.miao@marvell.com>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License version 2 as
@@ -90,7 +90,7 @@ static uint32_t lcd_qvga_pass_through_td
 };
 
 static uint32_t lcd_vga_transfer_tdo24m[] = {
-	CMD1(0xcf, 0x02), 	/* Blanking period control (1) */
+	CMD1(0xcf, 0x02),	/* Blanking period control (1) */
 	CMD2(0xd0, 0x08, 0x04),	/* Blanking period control (2) */
 	CMD1(0xd1, 0x01),	/* CKV timing control on/off */
 	CMD2(0xd2, 0x14, 0x00),	/* CKV 1,2 timing control */
@@ -132,7 +132,7 @@ static uint32_t lcd_qvga_pass_through_td
 };
 
 static uint32_t lcd_vga_transfer_tdo35s[] = {
-	CMD1(0xcf, 0x02), 	/* Blanking period control (1) */
+	CMD1(0xcf, 0x02),	/* Blanking period control (1) */
 	CMD2(0xd0, 0x08, 0x04),	/* Blanking period control (2) */
 	CMD1(0xd1, 0x01),	/* CKV timing control on/off */
 	CMD2(0xd2, 0x00, 0x1e),	/* CKV 1,2 timing control */
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

