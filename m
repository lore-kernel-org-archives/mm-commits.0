From: akpm@linux-foundation.org
Subject: - mips-au1xxx_ideh-use-null-as-firmware-revision-wildcard.patch removed from -mm tree
Date: Wed, 30 May 2007 16:28:28 -0700
Message-ID: <200705302328.l4UNSRF3007756@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771AbXE3X2r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 19:28:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junkio@cox.net, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mips au1xxx_ide.h: use NULL as firmware-revision wildcard
has been removed from the -mm tree.  Its filename was
     mips-au1xxx_ideh-use-null-as-firmware-revision-wildcard.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mips au1xxx_ide.h: use NULL as firmware-revision wildcard
From: Junio C Hamano <junkio@cox.net>

This updates the DMA whitelist in MIPS specific au1xxx ide driver to use NULL
instead of "ALL" as the wildcard.

Signed-off-by: Junio C Hamano <junkio@cox.net>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/mach-au1x00/au1xxx_ide.h |   28 ++++++++++----------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN include/asm-mips/mach-au1x00/au1xxx_ide.h~mips-au1xxx_ideh-use-null-as-firmware-revision-wildcard include/asm-mips/mach-au1x00/au1xxx_ide.h
--- a/include/asm-mips/mach-au1x00/au1xxx_ide.h~mips-au1xxx_ideh-use-null-as-firmware-revision-wildcard
+++ a/include/asm-mips/mach-au1x00/au1xxx_ide.h
@@ -88,26 +88,26 @@ static const struct drive_list_entry dma
 /*
  * Hitachi
  */
-        { "HITACHI_DK14FA-20"    ,       "ALL"           },
-        { "HTS726060M9AT00"      ,       "ALL"           },
+        { "HITACHI_DK14FA-20"    ,       NULL            },
+        { "HTS726060M9AT00"      ,       NULL            },
 /*
  * Maxtor
  */
-        { "Maxtor 6E040L0"      ,       "ALL"           },
-        { "Maxtor 6Y080P0"      ,       "ALL"           },
-        { "Maxtor 6Y160P0"      ,       "ALL"           },
+        { "Maxtor 6E040L0"      ,       NULL            },
+        { "Maxtor 6Y080P0"      ,       NULL            },
+        { "Maxtor 6Y160P0"      ,       NULL            },
 /*
  * Seagate
  */
-        { "ST3120026A"          ,       "ALL"           },
-        { "ST320014A"           ,       "ALL"           },
-        { "ST94011A"            ,       "ALL"           },
-        { "ST340016A"           ,       "ALL"           },
+        { "ST3120026A"          ,       NULL            },
+        { "ST320014A"           ,       NULL            },
+        { "ST94011A"            ,       NULL            },
+        { "ST340016A"           ,       NULL            },
 /*
  * Western Digital
  */
-        { "WDC WD400UE-00HCT0"  ,       "ALL"           },
-        { "WDC WD400JB-00JJC0"  ,       "ALL"           },
+        { "WDC WD400UE-00HCT0"  ,       NULL            },
+        { "WDC WD400JB-00JJC0"  ,       NULL            },
         { NULL                  ,       NULL            }
 };
 
@@ -116,9 +116,9 @@ static const struct drive_list_entry dma
 /*
  * Western Digital
  */
-        { "WDC WD100EB-00CGH0"  ,       "ALL"           },
-        { "WDC WD200BB-00AUA1"  ,       "ALL"           },
-        { "WDC AC24300L"        ,       "ALL"           },
+        { "WDC WD100EB-00CGH0"  ,       NULL            },
+        { "WDC WD200BB-00AUA1"  ,       NULL            },
+        { "WDC AC24300L"        ,       NULL            },
         { NULL                  ,       NULL            }
 };
 #endif
_

Patches currently in -mm which might be from junkio@cox.net are
