From: akpm@linux-foundation.org
Subject: + mfd-sm501-debug-typo-fix.patch added to -mm tree
Date: Mon, 26 Nov 2007 15:14:22 -0800
Message-ID: <200711262314.lAQNEMe3028010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50654 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755985AbXKZXPD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 18:15:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org


The patch titled
     MFD: SM501 debug typo fix
has been added to the -mm tree.  Its filename is
     mfd-sm501-debug-typo-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MFD: SM501 debug typo fix
From: Ben Dooks <ben-linux@fluff.org>

Remove errnoeous x character from dev_dbg() call that stops the driver
compiling under debug.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sm501.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mfd/sm501.c~mfd-sm501-debug-typo-fix drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~mfd-sm501-debug-typo-fix
+++ a/drivers/mfd/sm501.c
@@ -156,7 +156,7 @@ static void sm501_dump_clk(struct sm501_
 
 	dev_dbg(sm->dev, "PM0[%c]: "
 		 "P2 %ld.%ld MHz (%ld), V2 %ld.%ld (%ld), "
-x		 "M %ld.%ld (%ld), MX1 %ld.%ld (%ld)\n",
+		 "M %ld.%ld (%ld), MX1 %ld.%ld (%ld)\n",
 		 (pmc & 3 ) == 0 ? '*' : '-',
 		 fmt_freq(decode_div(pll2, pm0, 24, 1<<29, 31, px_div)),
 		 fmt_freq(decode_div(pll2, pm0, 16, 1<<20, 15, misc_div)),
_

Patches currently in -mm which might be from ben-linux@fluff.org are

s3c24xx-ensure-we-only-configure-valid-gpios.patch
s3c2410-add-bus-number-to-spi-gpio-driver.patch
mfd-sm501-debug-typo-fix.patch
