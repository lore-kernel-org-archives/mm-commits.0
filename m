From: akpm@linux-foundation.org
Subject: - uvesafb-documentation-uvesafb-add-info-about-pmipal-yrap-and-ypan-being-available-only-on-x86.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:57:35 -0700
Message-ID: <200710160457.l9G4vZBe009864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37600 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753404AbXJPE5i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:57:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: spock@gentoo.org, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     uvesafb: add info about pmipal, yrap and ypan being available only on x86
has been removed from the -mm tree.  Its filename was
     uvesafb-documentation-uvesafb-add-info-about-pmipal-yrap-and-ypan-being-available-only-on-x86.patch

This patch was dropped because it was folded into uvesafb-documentation.patch

------------------------------------------------------
Subject: uvesafb: add info about pmipal, yrap and ypan being available only on x86
From: Michal Januszewski <spock@gentoo.org>

Features that use the Protected Mode Interface are available on x86 only. 
Document this in the uvesafb description.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/uvesafb.txt |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN Documentation/fb/uvesafb.txt~uvesafb-documentation-uvesafb-add-info-about-pmipal-yrap-and-ypan-being-available-only-on-x86 Documentation/fb/uvesafb.txt
--- a/Documentation/fb/uvesafb.txt~uvesafb-documentation-uvesafb-add-info-about-pmipal-yrap-and-ypan-being-available-only-on-x86
+++ a/Documentation/fb/uvesafb.txt
@@ -59,11 +59,12 @@ Accepted options:
 ypan    Enable display panning using the VESA protected mode
         interface.  The visible screen is just a window of the
         video memory, console scrolling is done by changing the
-        start of the window.
+        start of the window.  Available on x86 only.
 
 ywrap   Same as ypan, but assumes your gfx board can wrap-around
         the video memory (i.e. starts reading from top if it
         reaches the end of video memory).  Faster than ypan.
+        Available on x86 only.
 
 redraw  Scroll by redrawing the affected part of the screen, this
         is the safe (and slow) default.
@@ -75,7 +76,7 @@ vgapal  Use the standard VGA registers f
 
 pmipal  Use the protected mode interface for palette changes.
         This is the default if the protected mode interface is
-        available.
+        available.  Available on x86 only.
 
 mtrr:n  Setup memory type range registers for the framebuffer
         where n:
_

Patches currently in -mm which might be from spock@gentoo.org are

fbdev-export-fb_destroy_modelist.patch
connector-change-connectors-max-message-size.patch
uvesafb-add-connector-entries.patch
uvesafb-the-driver-core.patch
uvesafb-documentation.patch
uvesafb-documentation-uvesafb-add-info-about-pmipal-yrap-and-ypan-being-available-only-on-x86.patch
fbdev-find-mode-with-the-highest-safest-refresh-rate-in-fb_find_mode.patch
