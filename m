From: akpm@linux-foundation.org
Subject: + mac68k-add-nubus-card-definitions-and-a-typo-fix.patch added to -mm tree
Date: Mon, 19 Nov 2007 18:15:12 -0800
Message-ID: <200711200215.lAK2FCTh008973@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43277 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762209AbXKTCP1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 21:15:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fthain@telegraphics.com.au, geert@linux-m68k.org, zippel@linux-m68k.org


The patch titled
     mac68k: add nubus card definitions and a typo fix
has been added to the -mm tree.  Its filename is
     mac68k-add-nubus-card-definitions-and-a-typo-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

mac68k-mailing-list-addresss.patch
mac68k-macii-adb-comment-correction.patch
mac68k-remove-dead-code.patch
mac68k-add-nubus-card-definitions-and-a-typo-fix.patch
