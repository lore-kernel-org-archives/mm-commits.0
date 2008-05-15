From: akpm@linux-foundation.org
Subject: + fix-parenthesis-in-include-asm-mips-gich.patch added to -mm tree
Date: Thu, 15 May 2008 11:53:04 -0700
Message-ID: <200805151853.m4FIr42Z005195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752087AbYEOSxr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 14:53:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, ralf@linux-mips.org


The patch titled
     fix parenthesis in include/asm-mips/gic.h
has been added to the -mm tree.  Its filename is
     fix-parenthesis-in-include-asm-mips-gich.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix parenthesis in include/asm-mips/gic.h
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Parenthesis fix in include/asm-mips/gic.h

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/gic.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-mips/gic.h~fix-parenthesis-in-include-asm-mips-gich include/asm-mips/gic.h
--- a/include/asm-mips/gic.h~fix-parenthesis-in-include-asm-mips-gich
+++ a/include/asm-mips/gic.h
@@ -330,7 +330,7 @@
 
 #define GIC_SH_RMASK_OFS		0x0300
 #define GIC_CLR_INTR_MASK(intr, val) \
-	GICWRITE(GIC_REG_ADDR(SHARED, GIC_SH_RMASK_OFS + 4 + (((((intr) / 32) ^ 1) - 1) * 4)), ((val) << ((intr) % 32))
+	GICWRITE(GIC_REG_ADDR(SHARED, GIC_SH_RMASK_OFS + 4 + (((((intr) / 32) ^ 1) - 1) * 4)), ((val) << ((intr) % 32)))
 
 /* Register Map for Local Section */
 #define GIC_VPE_CTL_OFS			0x0000
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

fix-parenthesis-in-include-asm-arm-arch-omap-controlh.patch
fix-parenthesis-in-include-asm-mips-gich.patch
linux-next.patch
reiser4.patch

