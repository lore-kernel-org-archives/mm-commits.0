From: akpm@linux-foundation.org
Subject: - mac68k-add-nubus-card-definitions-and-a-typo-fix.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:35:02 -0800
Message-ID: <200802052234.m15MYhV1012549@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56236 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761003AbYBEWmb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fthain@telegraphics.com.au, geert@linux-m68k.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     mac68k: add nubus card definitions and a typo fix
has been removed from the -mm tree.  Its filename was
     mac68k-add-nubus-card-definitions-and-a-typo-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mac68k: add nubus card definitions and a typo fix
From: Finn Thain <fthain@telegraphics.com.au>

Add some new card definitions and fix a typo (from Eugen Paiuc).

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nubus.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/nubus.h~mac68k-add-nubus-card-definitions-and-a-typo-fix include/linux/nubus.h
--- a/include/linux/nubus.h~mac68k-add-nubus-card-definitions-and-a-typo-fix
+++ a/include/linux/nubus.h
@@ -132,10 +132,12 @@ enum nubus_drhw {
 	NUBUS_DRHW_RDIUS_DCGX     = 0x027C, /* Radius DirectColor/GX */
 	NUBUS_DRHW_RDIUS_PC8      = 0x0291, /* Radius PrecisionColor 8 */
 	NUBUS_DRHW_LAPIS_PCS8     = 0x0292, /* Lapis ProColorServer 8 */
-	NUBUS_DRHW_RASTER_24LXI   = 0x02A0, /* RasterOps 8/24 XLi */
+	NUBUS_DRHW_RASTER_24XLI   = 0x02A0, /* RasterOps 8/24 XLi */
 	NUBUS_DRHW_RASTER_PBPGT   = 0x02A5, /* RasterOps PaintBoard Prism GT */
 	NUBUS_DRHW_EMACH_FSX      = 0x02AE, /* E-Machines Futura SX */
+	NUBUS_DRHW_RASTER_24XLTV  = 0x02B7, /* RasterOps 24XLTV */
 	NUBUS_DRHW_SMAC_THUND24   = 0x02CB, /* SuperMac Thunder/24 */
+	NUBUS_DRHW_SMAC_THUNDLGHT = 0x03D9, /* SuperMac ThunderLight */
 	NUBUS_DRHW_RDIUS_PC24XP   = 0x0406, /* Radius PrecisionColor 24Xp */
 	NUBUS_DRHW_RDIUS_PC24X    = 0x040A, /* Radius PrecisionColor 24X */
 	NUBUS_DRHW_RDIUS_PC8XJ    = 0x040B, /* Radius PrecisionColor 8XJ */
_

Patches currently in -mm which might be from fthain@telegraphics.com.au are

origin.patch
