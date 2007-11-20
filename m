From: akpm@linux-foundation.org
Subject: + m68k-array_size-cleanup.patch added to -mm tree
Date: Mon, 19 Nov 2007 18:14:56 -0800
Message-ID: <200711200214.lAK2Euxg008932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33503 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760315AbXKTCPP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 21:15:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alex@flawedcode.org, geert@linux-m68k.org, zippel@linux-m68k.org


The patch titled
     m68k: ARRAY_SIZE() cleanup
has been added to the -mm tree.  Its filename is
     m68k-array_size-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-arm.patch
git-mips.patch
git-netdev-all.patch
m68k-array_size-cleanup.patch
dio-array_size-cleanup.patch
