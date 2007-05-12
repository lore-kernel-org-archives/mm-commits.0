From: akpm@linux-foundation.org
Subject: - video-remove-archaic-if-construct-from-kconfig-file.patch removed from -mm tree
Date: Fri, 11 May 2007 22:35:50 -0700
Message-ID: <200705120535.l4C5Zo06002328@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:32985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756359AbXELFf6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:35:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     VIDEO: remove archaic if[] construct from Kconfig file
has been removed from the -mm tree.  Its filename was
     video-remove-archaic-if-construct-from-kconfig-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: VIDEO: remove archaic if[] construct from Kconfig file
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the obsolete "if [ ]" construct from the video console Kconfig
file.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/Kconfig |    7 -------
 1 file changed, 7 deletions(-)

diff -puN drivers/video/console/Kconfig~video-remove-archaic-if-construct-from-kconfig-file drivers/video/console/Kconfig
--- a/drivers/video/console/Kconfig~video-remove-archaic-if-construct-from-kconfig-file
+++ a/drivers/video/console/Kconfig
@@ -19,13 +19,6 @@ config VGA_CONSOLE
 
 	  Say Y.
 
-#	if [ "$CONFIG_PCI" = "y" -a "$CONFIG_VGA_CONSOLE" = "y" ]; then
-#	   bool '   Allow VGA on any bus?' CONFIG_VGA_HOSE
-#	   if [ "$CONFIG_VGA_HOSE" = "y" ]; then
-#	      define_bool CONFIG_DUMMY_CONSOLE y
-#	   fi
-#	fi
-
 config VGACON_SOFT_SCROLLBACK
        bool "Enable Scrollback Buffer in System RAM"
        depends on VGA_CONSOLE
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
git-arm.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
git-avr32.patch
git-dvb.patch
git-ieee1394.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
