From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-ep93xx_blc-remove-duplicated-header-include.patch added to -mm tree
Date: Mon, 12 Dec 2011 15:39:54 -0800
Message-ID: <201112122339.pBCNdsJ2023810@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37882 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab1LLXj6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2011 18:39:58 -0500
Received: by eaad1 with SMTP id d1so88928eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2011 15:39:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, hsweeten@visionengravers.com, rmallon@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight/ep93xx_bl.c: remove duplicated header include
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-ep93xx_blc-remove-duplicated-header-include.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Subject: Subject: drivers/video/backlight/ep93xx_bl.c: remove duplicated header include

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
drivers-video-backlight-ep93xx_blc-remove-duplicated-header-include.patch

