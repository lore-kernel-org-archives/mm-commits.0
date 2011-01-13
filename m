From: akpm@linux-foundation.org
Subject: [merged] decompressors-remove-unused-function-from-lib-decompress_unlzmac.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:10:19 -0800
Message-ID: <201101132013.p0DKD0He030346@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933786Ab1AMUZR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:25:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasse.collin@tukaani.org, alain@knaff.lu, albin.tonnerre@free-electrons.com, hpa@zytor.com, phillip@lougher.demon.co.uk, mm-commits@vger.kernel.org


The patch titled
     Decompressors: remove unused function from lib/decompress_unlzma.c
has been removed from the -mm tree.  Its filename was
     decompressors-remove-unused-function-from-lib-decompress_unlzmac.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
