From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-jornada720_blc-fix-build.patch added to -mm tree
Date: Wed, 22 Jul 2009 15:35:32 -0700
Message-ID: <200907222235.n6MMZWLC007761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754125AbZGVWfq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Jul 2009 18:35:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristoffer.ericson@gmail.com, rpurdie@rpsys.net


The patch titled
     drivers/video/backlight/jornada720_bl.c: fix build
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-jornada720_blc-fix-build.patch

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

drivers-video-backlight-jornada720_blc-fix-build.patch
updated-f-and-t-in-maintainers-kristoffer-ericson.patch

