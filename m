From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-ep93xx_blc-add-missing-include-of-linux-moduleh.patch removed from -mm tree
Date: Fri, 26 Aug 2011 12:06:44 -0700
Message-ID: <201108261903.p7QJ3Sli005698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753144Ab1HZTEH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 15:04:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, hsweeten@visionengravers.com, rmallon@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     drivers/video/backlight/ep93xx_bl.c: add missing include of linux/module.h
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-ep93xx_blc-add-missing-include-of-linux-moduleh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/backlight/ep93xx_bl.c: add missing include of linux/module.h
From: Axel Lin <axel.lin@gmail.com>

ep93xx_bl.c uses interfaces from linux/module.h,
so it should include that file. This patch fixes below build errors.

  CC [M]  drivers/video/backlight/ep93xx_bl.o
drivers/video/backlight/ep93xx_bl.c:138: error: 'THIS_MODULE' undeclared here (not in a function)
drivers/video/backlight/ep93xx_bl.c:158: error: expected declaration specifiers or '...' before string constant
drivers/video/backlight/ep93xx_bl.c:158: warning: data definition has no type or storage class
drivers/video/backlight/ep93xx_bl.c:158: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
drivers/video/backlight/ep93xx_bl.c:158: warning: function declaration isn't a prototype
drivers/video/backlight/ep93xx_bl.c:159: error: expected declaration specifiers or '...' before string constant
drivers/video/backlight/ep93xx_bl.c:159: warning: data definition has no type or storage class
drivers/video/backlight/ep93xx_bl.c:159: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
drivers/video/backlight/ep93xx_bl.c:159: warning: function declaration isn't a prototype
drivers/video/backlight/ep93xx_bl.c:160: error: expected declaration specifiers or '...' before string constant
drivers/video/backlight/ep93xx_bl.c:160: warning: data definition has no type or storage class
drivers/video/backlight/ep93xx_bl.c:160: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
drivers/video/backlight/ep93xx_bl.c:160: warning: function declaration isn't a prototype
drivers/video/backlight/ep93xx_bl.c:161: error: expected declaration specifiers or '...' before string constant
drivers/video/backlight/ep93xx_bl.c:161: warning: data definition has no type or storage class
drivers/video/backlight/ep93xx_bl.c:161: warning: type defaults to 'int' in declaration of 'MODULE_ALIAS'
drivers/video/backlight/ep93xx_bl.c:161: warning: function declaration isn't a prototype

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ep93xx_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/ep93xx_bl.c~drivers-video-backlight-ep93xx_blc-add-missing-include-of-linux-moduleh drivers/video/backlight/ep93xx_bl.c
--- a/drivers/video/backlight/ep93xx_bl.c~drivers-video-backlight-ep93xx_blc-add-missing-include-of-linux-moduleh
+++ a/drivers/video/backlight/ep93xx_bl.c
@@ -11,7 +11,7 @@
  * BRIGHT, on the Cirrus EP9307, EP9312, and EP9315 processors.
  */
 
