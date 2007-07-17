From: akpm@linux-foundation.org
Subject: - omap-add-ti-omap1610-accelerator-entry.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:08:20 -0700
Message-ID: <200707172308.l6HN8KgY012278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35779 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936513AbXGQXPu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: imre.deak@solidboot.com, adaplas@pol.net, soni.trilok@gmail.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     OMAP: add TI OMAP1610 accelerator entry.
has been removed from the -mm tree.  Its filename was
     omap-add-ti-omap1610-accelerator-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: OMAP: add TI OMAP1610 accelerator entry.
From: Imre Deak <imre.deak@solidboot.com>

Signed-off-by: Trilok Soni <soni.trilok@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fb.h |    1 +
 1 file changed, 1 insertion(+)

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

origin.patch
