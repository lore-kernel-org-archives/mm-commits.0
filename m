From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-l4f00242t03c-use-pr_fmt.patch removed from -mm tree
Date: Thu, 31 May 2012 12:18:55 -0700
Message-ID: <20120531191855.58F61A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:38663 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023Ab2EaTS4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:18:56 -0400
Received: by mail-vb0-f74.google.com with SMTP id l22so134438vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:18:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, alberto@amarulasolutions.com, joe@perches.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/l4f00242t03.c: use pr_fmt
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-l4f00242t03c-use-pr_fmt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/l4f00242t03.c: use pr_fmt

This driver uses pr_debug(), so provide it with the appropriate prefixing.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Alberto Panizzo <alberto@amarulasolutions.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/l4f00242t03.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/backlight/l4f00242t03.c~drivers-video-backlight-l4f00242t03c-use-pr_fmt drivers/video/backlight/l4f00242t03.c
--- a/drivers/video/backlight/l4f00242t03.c~drivers-video-backlight-l4f00242t03c-use-pr_fmt
+++ a/drivers/video/backlight/l4f00242t03.c
@@ -11,6 +11,8 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/device.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

