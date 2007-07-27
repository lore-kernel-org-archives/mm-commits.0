From: akpm@linux-foundation.org
Subject: + s3c2410-fixup-after-arch-moves.patch added to -mm tree
Date: Thu, 26 Jul 2007 18:34:04 -0700
Message-ID: <200707270134.l6R1Y4av032049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52191 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761471AbXG0Bev (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 21:34:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@fluff.org, a.zummo@towertech.it, ben-linux@fluff.org


The patch titled
     s3c2410: fixup after arch moves
has been added to the -mm tree.  Its filename is
     s3c2410-fixup-after-arch-moves.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: s3c2410: fixup after arch moves
From: Ben Dooks <ben@fluff.org>

Fixup the changes from moving around the arch support for s3c24xx based
systems.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-s3c.c~s3c2410-fixup-after-arch-moves drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~s3c2410-fixup-after-arch-moves
+++ a/drivers/rtc/rtc-s3c.c
@@ -29,7 +29,7 @@
 
 #include <asm/mach/time.h>
 
-#include <asm/arch/regs-rtc.h>
+#include <asm/plat-s3c/regs-rtc.h>
 
 /* I have yet to find an S3C implementation with more than one
  * of these rtc blocks in */
_

Patches currently in -mm which might be from ben@fluff.org are

s3c2410-fixup-after-arch-moves.patch
