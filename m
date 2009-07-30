From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-jornada720_blc-fix-build.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:37:05 -0700
Message-ID: <200907302037.n6UKb5Y4010789@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026AbZG3UhQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:37:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristoffer.ericson@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     drivers/video/backlight/jornada720_bl.c: fix build
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-jornada720_blc-fix-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/backlight/jornada720_bl.c: fix build
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>

Signed-off-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/jornada720_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/jornada720_bl.c~drivers-video-backlight-jornada720_blc-fix-build drivers/video/backlight/jornada720_bl.c
--- a/drivers/video/backlight/jornada720_bl.c~drivers-video-backlight-jornada720_blc-fix-build
+++ a/drivers/video/backlight/jornada720_bl.c
@@ -72,7 +72,7 @@ static int jornada_bl_update_status(stru
 		if (jornada_ssp_byte(SETBRIGHTNESS) != TXDUMMY) {
 			printk(KERN_INFO "bl : failed to set brightness\n");
 			ret = -ETIMEDOUT;
-			goto out
+			goto out;
 		}
 
 		/* at this point we expect that the mcu has accepted
_

Patches currently in -mm which might be from kristoffer.ericson@gmail.com are

origin.patch

