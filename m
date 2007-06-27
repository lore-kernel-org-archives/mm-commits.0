From: akpm@linux-foundation.org
Subject: + omap-add-ti-omap1610-accelerator-entry.patch added to -mm tree
Date: Tue, 26 Jun 2007 17:29:18 -0700
Message-ID: <200706270029.l5R0TIXJ006337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45418 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154AbXF0A3b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 20:29:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: imre.deak@solidboot.com, adaplas@pol.net, soni.trilok@gmail.com, tony@atomide.com


The patch titled
     OMAP: add TI OMAP1610 accelerator entry.
has been added to the -mm tree.  Its filename is
     omap-add-ti-omap1610-accelerator-entry.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: OMAP: add TI OMAP1610 accelerator entry.
From: Imre Deak <imre.deak@solidboot.com>

Signed-off-by: Trilok Soni <soni.trilok@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fb.h |    1 +
 1 files changed, 1 insertion(+)

diff -puN include/linux/fb.h~omap-add-ti-omap1610-accelerator-entry include/linux/fb.h
--- a/include/linux/fb.h~omap-add-ti-omap1610-accelerator-entry
+++ a/include/linux/fb.h
@@ -119,6 +119,7 @@ struct dentry;
 #define FB_ACCEL_NV_40          46      /* nVidia Arch 40               */
 #define FB_ACCEL_XGI_VOLARI_V	47	/* XGI Volari V3XT, V5, V8      */
 #define FB_ACCEL_XGI_VOLARI_Z	48	/* XGI Volari Z7                */
+#define FB_ACCEL_OMAP1610	49	/* TI OMAP16xx                  */
 #define FB_ACCEL_NEOMAGIC_NM2070 90	/* NeoMagic NM2070              */
 #define FB_ACCEL_NEOMAGIC_NM2090 91	/* NeoMagic NM2090              */
 #define FB_ACCEL_NEOMAGIC_NM2093 92	/* NeoMagic NM2093              */
_

Patches currently in -mm which might be from imre.deak@solidboot.com are

omap-add-ti-omap-framebuffer-driver.patch
omap-add-ti-omap1610-accelerator-entry.patch
omap-add-ti-omap1-internal-lcd-controller.patch
omap-add-ti-omap2-internal-display-controller-support.patch
omap-add-ti-omap1-external-lcd-controller-support-sossi.patch
omap-add-ti-omap2-external-lcd-controller-support-rfbi.patch
omap-add-external-epson-hwa742-lcd-controller-support.patch
omap-add-external-epson-blizzard-lcd-controller-support.patch
omap-lcd-panel-support-for-the-ti-omap-h4-board.patch
omap-lcd-panel-support-for-the-ti-omap-h3-board.patch
omap-lcd-panel-support-for-the-ti-omap1610-innovator-board.patch
omap-lcd-panel-support-for-the-ti-omap1510-innovator-board.patch
