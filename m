From: akpm@linux-foundation.org
Subject: [folded-merged] add-testcases-for-memset16-32-64-fix.patch
 removed from -mm tree
Date: Fri, 08 Sep 2017 16:01:16 -0700
Message-ID: <59b3213c.brnYarHRlmTWQTfh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49540 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757283AbdIHXBS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:01:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, hpa@zytor.com, ink@jurassic.park.msu.ru, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, mattst88@gmail.com, mawilcox@microsoft.com, minchan@kernel.org, mingo@elte.hu, mpe@ellerman.id.au, ralf@linux-mips.org, rmk+kernel@armlinux.org.uk, rth@twiddle.net, sam@ravnborg.org, sergey.senozhatsky@gmail.com, tglx@linutronix.de, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: add-testcases-for-memset16-32-64-fix
has been removed from the -mm tree.  Its filename was
     add-testcases-for-memset16-32-64-fix.patch

This patch was dropped because it was folded into add-testcases-for-memset16-32-64.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: add-testcases-for-memset16-32-64-fix

minor tweaks

Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN lib/string.c~add-testcases-for-memset16-32-64-fix lib/string.c
--- a/lib/string.c~add-testcases-for-memset16-32-64-fix
+++ a/lib/string.c
@@ -1150,7 +1150,6 @@ fail:
 	if (i < 256)
 		return (i << 24) | (j << 16) | k;
 	return 0;
-	return 0;
 }
 
 static __init int string_selftest_init(void)
@@ -1180,4 +1179,4 @@ fail:
 }
 
 module_init(string_selftest_init);
-#endif
+#endif	/* CONFIG_STRING_SELFTEST */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

add-testcases-for-memset16-32-64.patch
vga-optimise-console-scrolling-fix.patch
lib-add-test-for-bitmap_parselist-fix.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix.patch

