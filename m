From: akpm@linux-foundation.org
Subject: - s3c2410-fixup-after-arch-moves.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:54:40 -0700
Message-ID: <200707312354.l6VNse0e029165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42354 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759111AbXGaXz7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 19:55:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@fluff.org, a.zummo@towertech.it, ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     s3c2410: fixup after arch moves
has been removed from the -mm tree.  Its filename was
     s3c2410-fixup-after-arch-moves.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
