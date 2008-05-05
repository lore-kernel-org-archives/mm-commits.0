From: akpm@linux-foundation.org
Subject: + add-the-carmine-fb-driver-update.patch added to -mm tree
Date: Mon, 05 May 2008 14:04:01 -0700
Message-ID: <200805052104.m45L428S004951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760922AbYEEVEL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 17:04:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bigeasy@linutronix.de


The patch titled
     add-the-carmine-fb-driver update
has been added to the -mm tree.  Its filename is
     add-the-carmine-fb-driver-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: add-the-carmine-fb-driver update
From: Sebastian Siewior <bigeasy@linutronix.de>

v8: removed init 0 from static carmine_modedb


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/carminefb.c |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN drivers/video/carminefb.c~add-the-carmine-fb-driver-update drivers/video/carminefb.c
--- a/drivers/video/carminefb.c~add-the-carmine-fb-driver-update
+++ a/drivers/video/carminefb.c
@@ -88,21 +88,10 @@ static const struct fb_videomode carmine
 		.name		= "640x480",
 		.xres		= 640,
 		.yres		= 480,
-		.pixclock	= 0,
-		.left_margin	= 0,
-		.right_margin	= 0,
-		.upper_margin	= 0,
-		.lower_margin	= 0,
-		.hsync_len	= 0,
-		.vsync_len	= 0,
-		.sync		= 0,
-		.vmode		= 0,
-		.flag		= 0,
 	}, {
 		.name		= "800x600",
 		.xres		= 800,
 		.yres		= 600,
-		.pixclock	= 0,
 	},
 };
 
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

linux-next.patch
add-the-carmine-fb-driver.patch
add-the-carmine-fb-driver-update.patch

