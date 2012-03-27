From: akpm@linux-foundation.org
Subject: + backlight-fix-typo-in-tosa_lcdc.patch added to -mm tree
Date: Tue, 27 Mar 2012 16:38:59 -0700
Message-ID: <20120327233859.AEA56A042C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:36852 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab2C0XjB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Mar 2012 19:39:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: standby24x7@gmail.com, stable@vger.kernel.org


The patch titled
     Subject: backlight: fix typo in tosa_lcd.c
has been added to the -mm tree.  Its filename is
     backlight-fix-typo-in-tosa_lcdc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: backlight: fix typo in tosa_lcd.c

Patches currently in -mm which might be from standby24x7@gmail.com are

origin.patch
backlight-fix-typo-in-tosa_lcdc.patch
linux-next.patch

