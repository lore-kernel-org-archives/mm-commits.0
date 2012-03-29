From: akpm@linux-foundation.org
Subject: [merged] backlight-fix-typo-in-tosa_lcdc.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:14:32 -0700
Message-ID: <20120329191432.5CAD0A01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:45139 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933762Ab2C2TOf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:14:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: standby24x7@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: fix typo in tosa_lcd.c
has been removed from the -mm tree.  Its filename was
     backlight-fix-typo-in-tosa_lcdc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Masanari Iida <standby24x7@gmail.com>
Subject: backlight: fix typo in tosa_lcd.c

Fix typo in drivers/video/backlight/tosa_lcd.c
"tosa_lcd_reume" should be "tosa_lcd_resume".

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/tosa_lcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/tosa_lcd.c~backlight-fix-typo-in-tosa_lcdc drivers/video/backlight/tosa_lcd.c
--- a/drivers/video/backlight/tosa_lcd.c~backlight-fix-typo-in-tosa_lcdc
+++ a/drivers/video/backlight/tosa_lcd.c
@@ -271,7 +271,7 @@ static int tosa_lcd_resume(struct spi_de
 }
 #else
 #define tosa_lcd_suspend	NULL
-#define tosa_lcd_reume NULL
+#define tosa_lcd_resume NULL
 #endif
 
 static struct spi_driver tosa_lcd_driver = {
_

Patches currently in -mm which might be from standby24x7@gmail.com are

origin.patch
linux-next.patch

