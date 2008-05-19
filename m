From: akpm@linux-foundation.org
Subject: - fix-parenthesis-in-include-asm-arm-arch-omap-controlh.patch removed from -mm tree
Date: Mon, 19 May 2008 02:18:37 -0700
Message-ID: <200805190918.m4J9IbMj025358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753696AbYESJTk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 05:19:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, paul@pwsan.com, rmk@arm.linux.org.uk, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     fix parenthesis in include/asm-arm/arch-omap/control.h
has been removed from the -mm tree.  Its filename was
     fix-parenthesis-in-include-asm-arm-arch-omap-controlh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix parenthesis in include/asm-arm/arch-omap/control.h
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Parenthesis fix in include/asm-arm/arch-omap/control.h

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-arm/arch-omap/control.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-arm/arch-omap/control.h~fix-parenthesis-in-include-asm-arm-arch-omap-controlh include/asm-arm/arch-omap/control.h
--- a/include/asm-arm/arch-omap/control.h~fix-parenthesis-in-include-asm-arm-arch-omap-controlh
+++ a/include/asm-arm/arch-omap/control.h
@@ -80,7 +80,7 @@
 #define OMAP24XX_CONTROL_SEC_TAP	(OMAP2_CONTROL_GENERAL + 0x0064)
 #define OMAP24XX_CONTROL_OCM_PUB_RAM_ADD	(OMAP2_CONTROL_GENERAL + 0x006c)
 #define OMAP24XX_CONTROL_EXT_SEC_RAM_START_ADD	(OMAP2_CONTROL_GENERAL + 0x0070)
-#define OMAP24XX_CONTROL_EXT_SEC_RAM_STOP_ADD	(OMAP2_CONTROL_GENERAL + 0x0074
+#define OMAP24XX_CONTROL_EXT_SEC_RAM_STOP_ADD	(OMAP2_CONTROL_GENERAL + 0x0074)
 #define OMAP24XX_CONTROL_SEC_STATUS		(OMAP2_CONTROL_GENERAL + 0x0080)
 #define OMAP24XX_CONTROL_SEC_ERR_STATUS		(OMAP2_CONTROL_GENERAL + 0x0084)
 #define OMAP24XX_CONTROL_STATUS			(OMAP2_CONTROL_GENERAL + 0x0088)
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

linux-next.patch
fix-parenthesis-in-include-asm-mips-gich.patch
fix-parenthesis-in-include-asm-mips-mach-au1x00-au1000h.patch
reiser4.patch

