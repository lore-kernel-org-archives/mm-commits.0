From: akpm@linux-foundation.org
Subject: [merged] backlight-da903x_bl-fix-checkpatch-warning.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:04:03 -0800
Message-ID: <20121218200404.212AD200061@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:58522 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUEG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:04:06 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so63215wib.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:04:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: da903x_bl: fix checkpatch warning
has been removed from the -mm tree.  Its filename was
     backlight-da903x_bl-fix-checkpatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch

