From: akpm@linux-foundation.org
Subject: [merged] backlight-l4f00242t03-fix-checkpatch-warning.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:04:22 -0800
Message-ID: <20121218200423.3AE9F200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f201.google.com ([74.125.82.201]:57146 "EHLO
	mail-we0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUEZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:04:25 -0500
Received: by mail-we0-f201.google.com with SMTP id t11so63429wey.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:04:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: l4f00242t03: fix checkpatch warning
has been removed from the -mm tree.  Its filename was
     backlight-l4f00242t03-fix-checkpatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 
