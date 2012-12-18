From: akpm@linux-foundation.org
Subject: [merged] backlight-tdo24m-fix-checkpatch-warning.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:04:40 -0800
Message-ID: <20121218200441.19A4820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f73.google.com ([209.85.215.73]:51921 "EHLO
	mail-la0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUEn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:04:43 -0500
Received: by mail-la0-f73.google.com with SMTP id d3so63383lah.2
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:04:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: tdo24m: fix checkpatch warning
has been removed from the -mm tree.  Its filename was
     backlight-tdo24m-fix-checkpatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch

