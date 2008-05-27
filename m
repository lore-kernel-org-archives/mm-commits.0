From: akpm@linux-foundation.org
Subject: - fix-parenthesis-in-include-asm-mips-gich.patch removed from -mm tree
Date: Tue, 27 May 2008 00:26:53 -0700
Message-ID: <200805270726.m4R7QrLo014710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756291AbYE0Hck (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:32:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     fix parenthesis in include/asm-mips/gic.h
has been removed from the -mm tree.  Its filename was
     fix-parenthesis-in-include-asm-mips-gich.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
reiser4.patch

