From: akpm@linux-foundation.org
Subject: + fbdev-migrate-mailing-lists-to-vger.patch added to -mm tree
Date: Fri, 20 Nov 2009 16:40:43 -0800
Message-ID: <200911210040.nAL0ehr0012932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753872AbZKUAky (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 19:40:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org


The patch titled
     fbdev: migrate mailing lists to vger
has been added to the -mm tree.  Its filename is
     fbdev-migrate-mailing-lists-to-vger.patch

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
Subject: fbdev: migrate mailing lists to vger
From: Geert Uytterhoeven <geert@linux-m68k.org>

The fbdev mailing lists at SourceForge have been migrated to a single
mailing list at kernel.org: linux-fbdev@vger.kernel.org.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/framebuffer.txt |    6 ++----
 MAINTAINERS                      |   28 ++++++++++++++--------------
 2 files changed, 16 insertions(+), 18 deletions(-)

diff -puN Documentation/fb/framebuffer.txt~fbdev-migrate-mailing-lists-to-vger Documentation/fb/framebuffer.txt
--- a/Documentation/fb/framebuffer.txt~fbdev-migrate-mailing-lists-to-vger
+++ a/Documentation/fb/framebuffer.txt
@@ -312,10 +312,8 @@ and to the following documentation:
 8. Mailing list
 ---------------
 
-There are several frame buffer device related mailing lists at SourceForge:
-  - linux-fbdev-announce@lists.sourceforge.net, for announcements,
-  - linux-fbdev-user@lists.sourceforge.net, for generic user support,
-  - linux-fbdev-devel@lists.sourceforge.net, for project developers.
+There is a frame buffer device related mailing list at kernel.org:
+linux-fbdev@vger.kernel.org.
 
 Point your web browser to http://sourceforge.net/projects/linux-fbdev/ for
 subscription information and archive browsing.
diff -puN MAINTAINERS~fbdev-migrate-mailing-lists-to-vger MAINTAINERS
--- a/MAINTAINERS~fbdev-migrate-mailing-lists-to-vger
+++ a/MAINTAINERS
@@ -1040,7 +1040,7 @@ F:	drivers/serial/atmel_serial.c
 
 ATMEL LCDFB DRIVER
 M:	Nicolas Ferre <nicolas.ferre@atmel.com>
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	drivers/video/atmel_lcdfb.c
 F:	include/video/atmel_lcdc.h
@@ -2153,7 +2153,7 @@ F:	drivers/net/wan/dlci.c
 F:	drivers/net/wan/sdla.c
 
 FRAMEBUFFER LAYER
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 W:	http://linux-fbdev.sourceforge.net/
 S:	Orphan
 F:	Documentation/fb/
@@ -2176,7 +2176,7 @@ F:	drivers/i2c/busses/i2c-cpm.c
 
 FREESCALE IMX / MXC FRAMEBUFFER DRIVER
 M:	Sascha Hauer <kernel@pengutronix.de>
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/plat-mxc/include/mach/imxfb.h
@@ -2684,7 +2684,7 @@ S:	Supported
 F:	security/integrity/ima/
 
 IMS TWINTURBO FRAMEBUFFER DRIVER
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 S:	Orphan
 F:	drivers/video/imsttfb.c
 
@@ -2719,14 +2719,14 @@ F:	drivers/input/
 
 INTEL FRAMEBUFFER DRIVER (excluding 810 and 815)
 M:	Sylvain Meyer <sylvain.meyer@worldonline.fr>
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/fb/intelfb.txt
 F:	drivers/video/intelfb/
 
 INTEL 810/815 FRAMEBUFFER DRIVER
 M:	Antonino Daplas <adaplas@gmail.com>
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	drivers/video/i810/
 
@@ -3453,7 +3453,7 @@ S:	Supported
 
 MATROX FRAMEBUFFER DRIVER
 M:	Petr Vandrovec <vandrove@vc.cvut.cz>
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	drivers/video/matrox/matroxfb_*
 F:	include/linux/matroxfb.h
@@ -3840,7 +3840,7 @@ F:	fs/ntfs/
 
 NVIDIA (rivafb and nvidiafb) FRAMEBUFFER DRIVER
 M:	Antonino Daplas <adaplas@gmail.com>
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	drivers/video/riva/
 F:	drivers/video/nvidia/
@@ -3875,7 +3875,7 @@ F:	sound/soc/omap/
 
 OMAP FRAMEBUFFER SUPPORT
 M:	Imre Deak <imre.deak@nokia.com>
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 L:	linux-omap@vger.kernel.org
 S:	Maintained
 F:	drivers/video/omap/
@@ -4405,14 +4405,14 @@ F:	include/linux/qnxtypes.h
 
 RADEON FRAMEBUFFER DISPLAY DRIVER
 M:	Benjamin Herrenschmidt <benh@kernel.crashing.org>
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	drivers/video/aty/radeon*
 F:	include/linux/radeonfb.h
 
 RAGE128 FRAMEBUFFER DISPLAY DRIVER
 M:	Paul Mackerras <paulus@samba.org>
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	drivers/video/aty/aty128fb.c
 
@@ -4551,7 +4551,7 @@ F:	drivers/net/wireless/rtl818x/rtl8187*
 
 S3 SAVAGE FRAMEBUFFER DRIVER
 M:	Antonino Daplas <adaplas@gmail.com>
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	drivers/video/savage/
 
@@ -5722,7 +5722,7 @@ S:	Maintained
 
 UVESAFB DRIVER
 M:	Michal Januszewski <spock@gentoo.org>
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 W:	http://dev.gentoo.org/~spock/projects/uvesafb/
 S:	Maintained
 F:	Documentation/fb/uvesafb.txt
@@ -5777,7 +5777,7 @@ F:	drivers/mmc/host/via-sdmmc.c
 VIA UNICHROME(PRO)/CHROME9 FRAMEBUFFER DRIVER
 M:	Joseph Chan <JosephChan@via.com.tw>
 M:	Scott Fang <ScottFang@viatech.com.cn>
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	drivers/video/via/
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

fbdev-migrate-mailing-lists-to-vger.patch
linux-next.patch
vt-make-the-default-cursor-shape-configurable.patch
irq-fix-test-in-__exit-parport_mfc3_exit.patch

