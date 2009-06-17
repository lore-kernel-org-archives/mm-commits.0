From: akpm@linux-foundation.org
Subject: [merged] fbdev-add-video-modes-for-resolutions-and-timings-of-pal-rgb.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:39:06 -0700
Message-ID: <200906171839.n5HId66h005134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756095AbZFQSsy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:48:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulepanter@users.sourceforge.net, krzysztof.h1@poczta.fm, sparkie@lowbyte.de, mm-commits@vger.kernel.org


The patch titled
     fbdev: add video modes for resolutions and timings of PAL RGB
has been removed from the -mm tree.  Its filename was
     fbdev-add-video-modes-for-resolutions-and-timings-of-pal-rgb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: add video modes for resolutions and timings of PAL RGB
From: Paul Menzel <paulepanter@users.sourceforge.net>

This patch was taken from vga-sync-field version 0.0.3 [1][2].

[1] http://lowbyte.de/vga-sync-fields/vga-sync-fields-0.0.3.tgz
[2] http://git.hellersdorfer-jugendchor.de/?p=3Dvga2scart.git;a=3Dcommit;h=
=3Dc5c8ed6c51fc9879dbf38d8b91d5db6f4300ea03

Signed-off-by: Thomas Hilber <sparkie@lowbyte.de>
Signed-off-by: Paul Menzel <paulepanter@users.sourceforge.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/modedb.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/video/modedb.c~fbdev-add-video-modes-for-resolutions-and-timings-of-pal-rgb drivers/video/modedb.c
--- a/drivers/video/modedb.c~fbdev-add-video-modes-for-resolutions-and-timings-of-pal-rgb
+++ a/drivers/video/modedb.c
@@ -264,6 +264,14 @@ static const struct fb_videomode modedb[
 	/* 1280x800, 60 Hz, 47.403 kHz hsync, WXGA 16:10 aspect ratio */
 	NULL, 60, 1280, 800, 12048, 200, 64, 24, 1, 136, 3,
 	0, FB_VMODE_NONINTERLACED
+    }, {
+       /* 720x576i @ 50 Hz, 15.625 kHz hsync (PAL RGB) */
+       NULL, 50, 720, 576, 74074, 64, 16, 39, 5, 64, 5,
+       0, FB_VMODE_INTERLACED
+    }, {
+       /* 800x520i @ 50 Hz, 15.625 kHz hsync (PAL RGB) */
+       NULL, 50, 800, 520, 58823, 144, 64, 72, 28, 80, 5,
+       0, FB_VMODE_INTERLACED
     },
 };
 
_

Patches currently in -mm which might be from paulepanter@users.sourceforge.net are

origin.patch

