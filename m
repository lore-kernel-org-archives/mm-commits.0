From: akpm@linux-foundation.org
Subject: [merged] backlight-pcf50633-fix-checkpatch-warning.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:04:34 -0800
Message-ID: <20121218200434.A8A99100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:33819 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUEf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:04:35 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so125436ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:04:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: pcf50633: fix checkpatch warning
has been removed from the -mm tree.  Its filename was
     backlight-pcf50633-fix-checkpatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -136,8 +136,10 @@ static int pcf50633_bl_probe(struct plat
 
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

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch

