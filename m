From: akpm@linux-foundation.org
Subject: + maintainers-linux-fbdev-is-moderated.patch added to -mm tree
Date: Mon, 18 Feb 2008 01:55:04 -0800
Message-ID: <200802180956.m1I9u2p0018685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49519 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752033AbYBRJ4m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 04:56:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org


The patch titled
     MAINTAINERS: linux-fbdev is moderated
has been added to the -mm tree.  Its filename is
     maintainers-linux-fbdev-is-moderated.patch

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
Subject: MAINTAINERS: linux-fbdev is moderated
From: Geert Uytterhoeven <geert@linux-m68k.org>

While linux-fbdev is subscribers-only, non-subscribers are not plainly
rejected, but moderated, so the casual patch/comment/question comes through.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN MAINTAINERS~maintainers-linux-fbdev-is-moderated MAINTAINERS
--- a/MAINTAINERS~maintainers-linux-fbdev-is-moderated
+++ a/MAINTAINERS
@@ -697,7 +697,7 @@ S:	Supported
 ATMEL LCDFB DRIVER
 P:	Nicolas Ferre
 M:	nicolas.ferre@atmel.com
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
 ATMEL MACB ETHERNET DRIVER
@@ -1202,7 +1202,7 @@ S:	Maintained
 CYBLAFB FRAMEBUFFER DRIVER
 P:	Knut Petersen
 M:	Knut_Petersen@t-online.de
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
 CYCLADES 2X SYNC CARD DRIVER
@@ -1580,7 +1580,7 @@ S:	Supported
 FRAMEBUFFER LAYER
 P:	Antonino Daplas
 M:	adaplas@gmail.com
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	http://linux-fbdev.sourceforge.net/
 S:	Maintained
 
@@ -1965,7 +1965,7 @@ L:	linux1394-devel@lists.sourceforge.net
 S:	Maintained
 
 IMS TWINTURBO FRAMEBUFFER DRIVER
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Orphan
 
 INFINIBAND SUBSYSTEM
@@ -1999,13 +1999,13 @@ S:	Maintained
 INTEL FRAMEBUFFER DRIVER (excluding 810 and 815)
 P:	Sylvain Meyer
 M:	sylvain.meyer@worldonline.fr
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
 INTEL 810/815 FRAMEBUFFER DRIVER
 P:	Antonino Daplas
 M:	adaplas@gmail.com
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
 INTEL IA32 MICROCODE UPDATE SUPPORT
@@ -2601,7 +2601,7 @@ S:	Odd Fixes for 2.4; Maintained for 2.6
 MATROX FRAMEBUFFER DRIVER
 P:	Petr Vandrovec
 M:	vandrove@vc.cvut.cz
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
 MAX6650 HARDWARE MONITOR AND FAN CONTROLLER DRIVER
@@ -2910,7 +2910,7 @@ S:	Maintained
 NVIDIA (rivafb and nvidiafb) FRAMEBUFFER DRIVER
 P:	Antonino Daplas
 M:	adaplas@gmail.com
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
 OPENCORES I2C BUS DRIVER
@@ -3239,13 +3239,13 @@ S:	Maintained
 RADEON FRAMEBUFFER DISPLAY DRIVER
 P:	Benjamin Herrenschmidt
 M:	benh@kernel.crashing.org
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
 RAGE128 FRAMEBUFFER DISPLAY DRIVER
 P:	Paul Mackerras
 M:	paulus@samba.org
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
 RAYLINK/WEBGEAR 802.11 WIRELESS LAN DRIVER
@@ -3350,7 +3350,7 @@ S:	Maintained
 S3 SAVAGE FRAMEBUFFER DRIVER
 P:	Antonino Daplas
 M:	adaplas@gmail.com
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
 S390
_

Patches currently in -mm which might be from geert@linux-m68k.org are

maintainers-linux-fbdev-is-moderated.patch
