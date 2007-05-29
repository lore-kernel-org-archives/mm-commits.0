From: akpm@linux-foundation.org
Subject: + m68k-parenthesis-balance.patch added to -mm tree
Date: Tue, 29 May 2007 12:48:36 -0700
Message-ID: <200705291948.l4TJma53009979@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754170AbXE2Tst (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 15:48:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, geert@linux-m68k.org


The patch titled
     m68k: parenthesis balance
has been added to the -mm tree.  Its filename is
     m68k-parenthesis-balance.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m68k: parenthesis balance
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Balance parenthesis in m68k mac debug code.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/mac/debug.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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

m68k-parenthesis-balance.patch
arm26-remove-broken-and-unused-macro.patch
