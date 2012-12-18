From: akpm@linux-foundation.org
Subject: [merged] backlight-platform_lcd-fix-checkpatch-error.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:04:37 -0800
Message-ID: <20121218200437.9A2EF100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:38622 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUEi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:04:38 -0500
Received: by mail-qa0-f73.google.com with SMTP id a19so158404qad.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:04:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: platform_lcd: fix checkpatch error
has been removed from the -mm tree.  Its filename was
     backlight-platform_lcd-fix-checkpatch-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: platform_lcd: fix checkpatch error

This patch fixes the checkpatch error as below:

ERROR: spaces prohibited around that ':' (ctx:WxW)

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/platform_lcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/platform_lcd.c~backlight-platform_lcd-fix-checkpatch-error drivers/video/backlight/platform_lcd.c
--- a/drivers/video/backlight/platform_lcd.c~backlight-platform_lcd-fix-checkpatch-error
+++ a/drivers/video/backlight/platform_lcd.c
@@ -27,7 +27,7 @@ struct platform_lcd {
 	struct plat_lcd_data	*pdata;
 
 	unsigned int		 power;
-	unsigned int		 suspended : 1;
+	unsigned int		 suspended:1;
 };
 
 static inline struct platform_lcd *to_our_lcd(struct lcd_device *lcd)
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch

