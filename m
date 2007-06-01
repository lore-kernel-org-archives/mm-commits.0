From: akpm@linux-foundation.org
Subject: - m68k-parenthesis-balance.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:47:02 -0700
Message-ID: <200706011747.l51Hl1tR015102@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760702AbXFARrR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:47:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: parenthesis balance
has been removed from the -mm tree.  Its filename was
     m68k-parenthesis-balance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m68k: parenthesis balance
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Balance parenthesis in m68k mac debug code.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/mac/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/m68k/mac/debug.c~m68k-parenthesis-balance arch/m68k/mac/debug.c
--- a/arch/m68k/mac/debug.c~m68k-parenthesis-balance
+++ a/arch/m68k/mac/debug.c
@@ -71,7 +71,7 @@ void mac_debugging_short(int pos, short 
 
 	/* calculate current offset */
 	pengoffset = (unsigned char *)mac_videobase +
-		(150+line*2) * mac_rowbytes) + 80 * peng;
+		(150+line*2) * mac_rowbytes + 80 * peng;
 
 	pptr = pengoffset;
 
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
dm-add-missing-braces-in-driver-debug-code.patch
arm26-remove-broken-and-unused-macro.patch
