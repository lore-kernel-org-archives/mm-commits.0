From: akpm@linux-foundation.org
Subject: [merged] uvesafb-documentation-update.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:07:35 -0700
Message-ID: <200904071907.n37J7Zfa011362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755531AbZDGTJj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:09:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: spock@gentoo.org, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     uvesafb: documentation update
has been removed from the -mm tree.  Its filename was
     uvesafb-documentation-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uvesafb: documentation update
From: Michal Januszewski <spock@gentoo.org>

Update the uvesafb documentation to accurately reflect the default options
used by the driver.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/uvesafb.txt |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN Documentation/fb/uvesafb.txt~uvesafb-documentation-update Documentation/fb/uvesafb.txt
--- a/Documentation/fb/uvesafb.txt~uvesafb-documentation-update
+++ a/Documentation/fb/uvesafb.txt
@@ -59,7 +59,8 @@ Accepted options:
 ypan    Enable display panning using the VESA protected mode
         interface.  The visible screen is just a window of the
         video memory, console scrolling is done by changing the
-        start of the window.  Available on x86 only.
+        start of the window.  This option is available on x86
+        only and is the default option on that architecture.
 
 ywrap   Same as ypan, but assumes your gfx board can wrap-around
         the video memory (i.e. starts reading from top if it
@@ -67,7 +68,7 @@ ywrap   Same as ypan, but assumes your g
         Available on x86 only.
 
 redraw  Scroll by redrawing the affected part of the screen, this
-        is the safe (and slow) default.
+        is the default on non-x86.
 
 (If you're using uvesafb as a module, the above three options are
  used a parameter of the scroll option, e.g. scroll=ypan.)
@@ -182,7 +183,7 @@ from the Video BIOS if you set pixclock 
 
 --
  Michal Januszewski <spock@gentoo.org>
- Last updated: 2007-06-16
+ Last updated: 2009-03-30
 
  Documentation of the uvesafb options is loosely based on vesafb.txt.
 
_

Patches currently in -mm which might be from spock@gentoo.org are

origin.patch
linux-next.patch
fbdev-fix-color-component-field-length-documentation.patch
uvesafb-fix-color-component-length-for-pseudocolor-modes.patch

