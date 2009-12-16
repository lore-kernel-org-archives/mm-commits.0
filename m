From: akpm@linux-foundation.org
Subject: [merged] sm501-fix-use-of-old-asm-ioh-instead-of-linux-ioh.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:36:07 -0800
Message-ID: <200912162036.nBGKa75L013145@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935405AbZLPUgO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:36:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@simtec.co.uk, krzysztof.h1@poczta.fm, linux@simtec.co.uk, vince@simtec.co.uk, mm-commits@vger.kernel.org


The patch titled
     sm501: fix use of old <asm/io.h> instead of <linux/io.h>
has been removed from the -mm tree.  Its filename was
     sm501-fix-use-of-old-asm-ioh-instead-of-linux-ioh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sm501: fix use of old <asm/io.h> instead of <linux/io.h>
From: Ben Dooks <ben@simtec.co.uk>

Fix the old style use of <asm/io.h> by replacing it with <linux/io.h>.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Signed-off-by: Simtec Linux Team <linux@simtec.co.uk>
Cc: Vincent Sanders <vince@simtec.co.uk>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/sm501fb.c~sm501-fix-use-of-old-asm-ioh-instead-of-linux-ioh drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~sm501-fix-use-of-old-asm-ioh-instead-of-linux-ioh
+++ a/drivers/video/sm501fb.c
@@ -29,8 +29,8 @@
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/console.h>
+#include <linux/io.h>
 
-#include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/div64.h>
 
_

Patches currently in -mm which might be from ben@simtec.co.uk are

origin.patch
linux-next.patch
spi_s3c24xx-add-fiq-pseudo-dma-support.patch

