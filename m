From: akpm@linux-foundation.org
Subject: + uvesafb-documentation-uvesafb-add-info-about-pmipal-yrap-and-ypan-being-available-only-on-x86.patch added to -mm tree
Date: Wed, 15 Aug 2007 13:58:32 -0700
Message-ID: <200708152058.l7FKwWJa014673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53238 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751743AbXHOU6l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 16:58:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: spock@gentoo.org, adaplas@pol.net


The patch titled
     uvesafb: add info about pmipal, yrap and ypan being available only on x86
has been added to the -mm tree.  Its filename is
     uvesafb-documentation-uvesafb-add-info-about-pmipal-yrap-and-ypan-being-available-only-on-x86.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
uvesafb-the-driver-core-uvesafb-set-the-refresh-rate-to-60hz-if-nocrtc-is-used.patch
uvesafb-the-driver-core-uvesafb-always-use-mutexes-when-accessing-uvfb_tasks.patch
uvesafb-the-driver-core-uvesafb-fix-a-typo-in-a-warning.patch
uvesafb-the-driver-core-uvesafb-use-visual_truecolor-as-the-default-visual.patch
uvesafb-the-driver-core-uvesafb-use-the-default-refresh-rate-if-the-monitor-limits-are-not-set.patch
uvesafb-the-driver-core-uvesafb-try-to-set-mode-with-default-timings-if-setting-it-with-our-own-timings-failed.patch
uvesafb-documentation.patch
uvesafb-documentation-uvesafb-add-info-about-pmipal-yrap-and-ypan-being-available-only-on-x86.patch
