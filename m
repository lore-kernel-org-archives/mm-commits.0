From: akpm@linux-foundation.org
Subject: [merged] backlight-hp680_bl-fix-checkpatch-error-and-warning.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:04:11 -0800
Message-ID: <20121218200412.3C62A20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:56423 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUEO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:04:14 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so63139bkc.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:04:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: hp680_bl: fix checkpatch error and warning
has been removed from the -mm tree.  Its filename was
     backlight-hp680_bl-fix-checkpatch-error-and-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: hp680_bl: fix checkpatch error and warning

This patch fixes the checkpatch error and warning as below:

WARNING: please, no space before tabs
WARNING: please, no spaces at the start of a line
ERROR: do not initialise statics to 0 or NULL
ERROR: code indent should use tabs where possible

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/hp680_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/hp680_bl.c~backlight-hp680_bl-fix-checkpatch-error-and-warning drivers/video/backlight/hp680_bl.c
--- a/drivers/video/backlight/hp680_bl.c~backlight-hp680_bl-fix-checkpatch-error-and-warning
+++ a/drivers/video/backlight/hp680_bl.c
@@ -26,7 +26,7 @@
 #define HP680_DEFAULT_INTENSITY 10
 
 static int hp680bl_suspended;
-static int current_intensity = 0;
+static int current_intensity;
 static DEFINE_SPINLOCK(bl_lock);
 
 static void hp680bl_send_intensity(struct backlight_device *bd)
@@ -168,7 +168,7 @@ static int __init hp680bl_init(void)
 static void __exit hp680bl_exit(void)
 {
 	platform_device_unregister(hp680bl_device);
- 	platform_driver_unregister(&hp680bl_driver);
+	platform_driver_unregister(&hp680bl_driver);
 }
 
 module_init(hp680bl_init);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch

