From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-ep93xx_blc-remove-duplicated-header-include.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:29:57 -0800
Message-ID: <20120111212957.8C8261E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:48989 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121Ab2AKV36 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:29:58 -0500
Received: by mail-gx0-f202.google.com with SMTP id k3so134376ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:29:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, hsweeten@visionengravers.com, rmallon@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/ep93xx_bl.c: remove duplicated header include
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-ep93xx_blc-remove-duplicated-header-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/ep93xx_bl.c: remove duplicated header include

module.h is included twice.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ep93xx_bl.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/video/backlight/ep93xx_bl.c~drivers-video-backlight-ep93xx_blc-remove-duplicated-header-include drivers/video/backlight/ep93xx_bl.c
--- a/drivers/video/backlight/ep93xx_bl.c~drivers-video-backlight-ep93xx_blc-remove-duplicated-header-include
+++ a/drivers/video/backlight/ep93xx_bl.c
@@ -13,7 +13,6 @@
 
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/module.h>
 #include <linux/io.h>
 #include <linux/fb.h>
 #include <linux/backlight.h>
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

