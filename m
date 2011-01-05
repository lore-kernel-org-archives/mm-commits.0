From: akpm@linux-foundation.org
Subject: + decompressors-remove-unused-constant-from-inflateh.patch added to -mm tree
Date: Wed, 05 Jan 2011 15:13:10 -0800
Message-ID: <201101052313.p05NDAqI023825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751312Ab1AEX1Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jan 2011 18:27:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasse.collin@tukaani.org


The patch titled
     decompressors: remove unused constant from inflate.h
has been added to the -mm tree.  Its filename is
     decompressors-remove-unused-constant-from-inflateh.patch

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
Subject: decompressors: remove unused constant from inflate.h
From: Lasse Collin <lasse.collin@tukaani.org>

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/decompress/inflate.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/linux/decompress/inflate.h~decompressors-remove-unused-constant-from-inflateh include/linux/decompress/inflate.h
--- a/include/linux/decompress/inflate.h~decompressors-remove-unused-constant-from-inflateh
+++ a/include/linux/decompress/inflate.h
@@ -1,9 +1,6 @@
 #ifndef INFLATE_H
 #define INFLATE_H
 
-/* Other housekeeping constants */
-#define INBUFSIZ 4096
-
 int gunzip(unsigned char *inbuf, int len,
 	   int(*fill)(void*, unsigned int),
 	   int(*flush)(void*, unsigned int),
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

documentation-email-clientstxt-warn-about-word-wrap-bug-in-kmail.patch
decompressors-add-missing-init-ie-__init.patch
decompressors-get-rid-of-set_error_fn-macro.patch
decompressors-include-linux-slabh-in-linux-decompress-mmh.patch
decompressors-remove-unused-function-from-lib-decompress_unlzmac.patch
decompressors-fix-header-validation-in-decompress_unlzmac.patch
decompressors-check-for-read-errors-in-decompress_unlzmac.patch
decompressors-check-for-write-errors-in-decompress_unlzmac.patch
decompressors-validate-match-distance-in-decompress_unlzmac.patch
decompressors-check-for-write-errors-in-decompress_unlzoc.patch
decompressors-check-input-size-in-decompress_unlzoc.patch
decompressors-fix-callback-to-callback-mode-in-decompress_unlzoc.patch
decompressors-add-xz-decompressor-module.patch
decompressors-add-boot-time-xz-support.patch
decompressors-add-boot-time-xz-support-update.patch
x86-support-xz-compressed-kernel.patch
decompressors-check-input-size-in-decompress_inflatec.patch
decompressors-remove-unused-constant-from-inflateh.patch

