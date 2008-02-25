From: akpm@linux-foundation.org
Subject: - maintainers-linux-fbdev-is-moderated.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:44:18 -0800
Message-ID: <200802250044.m1P0iICX006098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752554AbYBYAoa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:44:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: linux-fbdev is moderated
has been removed from the -mm tree.  Its filename was
     maintainers-linux-fbdev-is-moderated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1579,7 +1579,7 @@ S:	Supported
 FRAMEBUFFER LAYER
 P:	Antonino Daplas
 M:	adaplas@gmail.com
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	http://linux-fbdev.sourceforge.net/
 S:	Maintained
 
@@ -1964,7 +1964,7 @@ L:	linux1394-devel@lists.sourceforge.net
 S:	Maintained
 
 IMS TWINTURBO FRAMEBUFFER DRIVER
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Orphan
 
 INFINIBAND SUBSYSTEM
@@ -1998,13 +1998,13 @@ S:	Maintained
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
@@ -2600,7 +2600,7 @@ S:	Odd Fixes for 2.4; Maintained for 2.6
 MATROX FRAMEBUFFER DRIVER
 P:	Petr Vandrovec
 M:	vandrove@vc.cvut.cz
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
 MAX6650 HARDWARE MONITOR AND FAN CONTROLLER DRIVER
@@ -2909,7 +2909,7 @@ S:	Maintained
 NVIDIA (rivafb and nvidiafb) FRAMEBUFFER DRIVER
 P:	Antonino Daplas
 M:	adaplas@gmail.com
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
 OPENCORES I2C BUS DRIVER
@@ -3238,13 +3238,13 @@ S:	Maintained
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
@@ -3349,7 +3349,7 @@ S:	Maintained
 S3 SAVAGE FRAMEBUFFER DRIVER
 P:	Antonino Daplas
 M:	adaplas@gmail.com
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
 S390
_

Patches currently in -mm which might be from geert@linux-m68k.org are

fb-add-support-for-foreign-endianness-add-support-for-choice-foreign-endianness.patch
