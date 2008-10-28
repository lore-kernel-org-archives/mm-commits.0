From: akpm@linux-foundation.org
Subject: + fbdev-fix-typo-in-drivers-video-modedbc.patch added to -mm tree
Date: Mon, 27 Oct 2008 17:48:41 -0700
Message-ID: <200810280048.m9S0mf6Z007231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751595AbYJ1AtF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 20:49:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jim.lkml@gmail.com, geert@linux-m68k.org, krzysztof.h1@poczta.fm


The patch titled
     fbdev: fix typo in drivers/video/modedb.c
has been added to the -mm tree.  Its filename is
     fbdev-fix-typo-in-drivers-video-modedbc.patch

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
Subject: fbdev: fix typo in drivers/video/modedb.c
From: Jiri Moravec <jim.lkml@gmail.com>

When I viewed drivers/video/modedb.c, I noticed a very old typo already
contained in 2.6.0.

This typo remained unheeded at least 5 years.  Clear evidence of its
importance.  ;)

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/modedb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/modedb.c~fbdev-fix-typo-in-drivers-video-modedbc drivers/video/modedb.c
--- a/drivers/video/modedb.c~fbdev-fix-typo-in-drivers-video-modedbc
+++ a/drivers/video/modedb.c
@@ -329,7 +329,7 @@ const struct fb_videomode vesa_modes[] =
 	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
 	  FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
 	/* 17 1152x864-75 VESA */
-	{ NULL, 75, 1153, 864, 9259, 256, 64, 32, 1, 128, 3,
+	{ NULL, 75, 1152, 864, 9259, 256, 64, 32, 1, 128, 3,
 	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
 	  FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
 	/* 18 1280x960-60 VESA */
_

Patches currently in -mm which might be from jim.lkml@gmail.com are

fbdev-fix-typo-in-drivers-video-modedbc.patch

