From: akpm@linux-foundation.org
Subject: [merged] fbdev-bfin-t350mcqb-fb-fix-lcd-dimensions.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:35:30 -0800
Message-ID: <200912162035.nBGKZUGs013103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935289AbZLPUfd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:35:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.hennerich@analog.com, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     fbdev: bfin-t350mcqb-fb: fix LCD dimensions
has been removed from the -mm tree.  Its filename was
     fbdev-bfin-t350mcqb-fb-fix-lcd-dimensions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: bfin-t350mcqb-fb: fix LCD dimensions
From: Michael Hennerich <michael.hennerich@analog.com>

The height/width framebuffer members need to be set in millimeters so that
software can do proper scaling.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/bfin-t350mcqb-fb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/bfin-t350mcqb-fb.c~fbdev-bfin-t350mcqb-fb-fix-lcd-dimensions drivers/video/bfin-t350mcqb-fb.c
--- a/drivers/video/bfin-t350mcqb-fb.c~fbdev-bfin-t350mcqb-fb-fix-lcd-dimensions
+++ a/drivers/video/bfin-t350mcqb-fb.c
@@ -487,8 +487,8 @@ static int __devinit bfin_t350mcqb_probe
 
 	fbinfo->var.nonstd = 0;
 	fbinfo->var.activate = FB_ACTIVATE_NOW;
-	fbinfo->var.height = -1;
-	fbinfo->var.width = -1;
+	fbinfo->var.height = 53;
+	fbinfo->var.width = 70;
 	fbinfo->var.accel_flags = 0;
 	fbinfo->var.vmode = FB_VMODE_NONINTERLACED;
 
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

origin.patch
linux-next.patch

