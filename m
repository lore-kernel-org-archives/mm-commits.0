From: akpm@linux-foundation.org
Subject: - mfd-sm501-debug-typo-fix.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:21:48 -0800
Message-ID: <200712010021.lB10LmVY031781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49625 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757317AbXLAA1h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:27:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     MFD: SM501 debug typo fix
has been removed from the -mm tree.  Its filename was
     mfd-sm501-debug-typo-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-mtd.patch
