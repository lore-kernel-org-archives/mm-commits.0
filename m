From: akpm@linux-foundation.org
Subject: + decompressors-remove-unused-function-from-lib-decompress_unlzmac.patch added to -mm tree
Date: Mon, 22 Nov 2010 12:01:27 -0800
Message-ID: <201011222001.oAMK1Rib006647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757448Ab0KVUCS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Nov 2010 15:02:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasse.collin@tukaani.org, alain@knaff.lu, albin.tonnerre@free-electrons.com, hpa@zytor.com, phillip@lougher.demon.co.uk


The patch titled
     Decompressors: remove unused function from lib/decompress_unlzma.c
has been added to the -mm tree.  Its filename is
     decompressors-remove-unused-function-from-lib-decompress_unlzmac.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Decompressors: remove unused function from lib/decompress_unlzma.c
From: Lasse Collin <lasse.collin@tukaani.org>

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alain Knaff <alain@knaff.lu>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unlzma.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN lib/decompress_unlzma.c~decompressors-remove-unused-function-from-lib-decompress_unlzmac lib/decompress_unlzma.c
--- a/lib/decompress_unlzma.c~decompressors-remove-unused-function-from-lib-decompress_unlzmac
+++ a/lib/decompress_unlzma.c
@@ -127,12 +127,6 @@ static inline void INIT rc_init_code(str
 }
 
 
-/* Called once. TODO: bb_maybe_free() */
-static inline void INIT rc_free(struct rc *rc)
-{
-	free(rc->buffer);
-}
