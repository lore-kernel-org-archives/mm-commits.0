From: akpm@linux-foundation.org
Subject: - m68k-array_size-cleanup.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:34:29 -0800
Message-ID: <200802052234.m15MYAc6012492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35375 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762685AbYBEWmc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex@flawedcode.org, geert@linux-m68k.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: ARRAY_SIZE() cleanup
has been removed from the -mm tree.  Its filename was
     m68k-array_size-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k: ARRAY_SIZE() cleanup
From: Alejandro Martinez Ruiz <alex@flawedcode.org>

Signed-off-by: Alejandro Martinez Ruiz <alex@flawedcode.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/amiga/amisound.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/m68k/amiga/amisound.c~m68k-array_size-cleanup arch/m68k/amiga/amisound.c
--- a/arch/m68k/amiga/amisound.c~m68k-array_size-cleanup
+++ a/arch/m68k/amiga/amisound.c
@@ -21,7 +21,7 @@ static const signed char sine_data[] = {
 	0,  39,  75,  103,  121,  127,  121,  103,  75,  39,
 	0, -39, -75, -103, -121, -127, -121, -103, -75, -39
 };
-#define DATA_SIZE	(sizeof(sine_data)/sizeof(sine_data[0]))
+#define DATA_SIZE	ARRAY_SIZE(sine_data)
 
 #define custom amiga_custom
 
_

Patches currently in -mm which might be from alex@flawedcode.org are

origin.patch
