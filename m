From: akpm@linux-foundation.org
Subject: + video-omap-suspected-typo-in-assignment.patch added to -mm tree
Date: Mon, 25 Oct 2010 16:03:38 -0700
Message-ID: <201010252303.o9PN3c03021485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751375Ab0JYXDt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Oct 2010 19:03:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nikai@nikai.net, tomi.valkeinen@nokia.com, tony@atomide.com


The patch titled
     drivers/video/omap/blizzard.c: suspected typo in assignment
has been added to the -mm tree.  Its filename is
     video-omap-suspected-typo-in-assignment.patch

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
Subject: drivers/video/omap/blizzard.c: suspected typo in assignment
From: Nicolas Kaiser <nikai@nikai.net>

Untested, but looks like an obvious typo to me.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
Cc: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap/blizzard.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/omap/blizzard.c~video-omap-suspected-typo-in-assignment drivers/video/omap/blizzard.c
--- a/drivers/video/omap/blizzard.c~video-omap-suspected-typo-in-assignment
+++ a/drivers/video/omap/blizzard.c
@@ -1590,7 +1590,7 @@ static int blizzard_init(struct omapfb_d
 	blizzard.auto_update_window.width = fbdev->panel->x_res;
 	blizzard.auto_update_window.height = fbdev->panel->y_res;
 	blizzard.auto_update_window.out_x = 0;
-	blizzard.auto_update_window.out_x = 0;
+	blizzard.auto_update_window.out_y = 0;
 	blizzard.auto_update_window.out_width = fbdev->panel->x_res;
 	blizzard.auto_update_window.out_height = fbdev->panel->y_res;
 	blizzard.auto_update_window.format = 0;
_

Patches currently in -mm which might be from nikai@nikai.net are

origin.patch
linux-next.patch
drivers-media-video-gspca-cpia1c-fix-error-check.patch
drivers-block-drbd-drbd_mainc-fix-error-path.patch
drivers-crypto-dubious-error-check.patch
video-omap-suspected-typo-in-assignment.patch

