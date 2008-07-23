From: akpm@linux-foundation.org
Subject: - add-the-carmine-fb-driver-update.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:36:23 -0700
Message-ID: <200807232349.m6NNn0LM018584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753091AbYGWXtJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:49:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bigeasy@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     add-the-carmine-fb-driver update
has been removed from the -mm tree.  Its filename was
     add-the-carmine-fb-driver-update.patch

This patch was dropped because it was folded into add-the-carmine-fb-driver.patch

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

origin.patch
add-the-carmine-fb-driver.patch
add-the-carmine-fb-driver-update.patch

