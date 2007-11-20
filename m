From: akpm@linux-foundation.org
Subject: + dio-array_size-cleanup.patch added to -mm tree
Date: Mon, 19 Nov 2007 18:14:58 -0800
Message-ID: <200711200214.lAK2EwMp008937@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52094 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762762AbXKTCPN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 21:15:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alex@flawedcode.org, geert@linux-m68k.org, zippel@linux-m68k.org


The patch titled
     dio: ARRAY_SIZE() cleanup
has been added to the -mm tree.  Its filename is
     dio-array_size-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dio: ARRAY_SIZE() cleanup
From: Alejandro Martinez Ruiz <alex@flawedcode.org>

Signed-off-by: Alejandro Martinez Ruiz <alex@flawedcode.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dio/dio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/dio/dio.c~dio-array_size-cleanup drivers/dio/dio.c
--- a/drivers/dio/dio.c~dio-array_size-cleanup
+++ a/drivers/dio/dio.c
@@ -88,7 +88,7 @@ static struct dioname names[] = 
 #undef DIONAME
 #undef DIOFBNAME
 
-#define NUMNAMES (sizeof(names) / sizeof(struct dioname))
+#define NUMNAMES ARRAY_SIZE(names)
 
 static const char *unknowndioname 
         = "unknown DIO board -- please email <linux-m68k@lists.linux-m68k.org>!";
_

Patches currently in -mm which might be from alex@flawedcode.org are

git-arm.patch
git-mips.patch
git-netdev-all.patch
m68k-array_size-cleanup.patch
dio-array_size-cleanup.patch
