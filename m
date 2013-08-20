From: akpm@linux-foundation.org
Subject: + lib-lz4-correct-the-lz4-license.patch added to -mm tree
Date: Tue, 20 Aug 2013 13:00:29 -0700
Message-ID: <5213cadd.HvrgYYkhk08rzR5l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36888 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab3HTUAa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Aug 2013 16:00:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ryao@gentoo.org, kyungsik.lee@lge.com, chanho.min@lge.com, rlaager@wiktel.com

Subject: + lib-lz4-correct-the-lz4-license.patch added to -mm tree
To: rlaager@wiktel.com,chanho.min@lge.com,kyungsik.lee@lge.com,ryao@gentoo.org
From: akpm@linux-foundation.org
Date: Tue, 20 Aug 2013 13:00:29 -0700


The patch titled
     Subject: lib/lz4: correct the LZ4 license
has been added to the -mm tree.  Its filename is
     lib-lz4-correct-the-lz4-license.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-lz4-correct-the-lz4-license.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-lz4-correct-the-lz4-license.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Richard Laager <rlaager@wiktel.com>
Subject: lib/lz4: correct the LZ4 license

The LZ4 code is listed as using the "BSD 2-Clause License".

Signed-off-by: Richard Laager <rlaager@wiktel.com>
Acked-by: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: Chanho Min <chanho.min@lge.com>
Cc: Richard Yao <ryao@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lz4/lz4_compress.c   |    4 ++--
 lib/lz4/lz4_decompress.c |    6 +++---
 lib/lz4/lz4hc_compress.c |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN lib/lz4/lz4_compress.c~lib-lz4-correct-the-lz4-license lib/lz4/lz4_compress.c
--- a/lib/lz4/lz4_compress.c~lib-lz4-correct-the-lz4-license
+++ a/lib/lz4/lz4_compress.c
@@ -437,7 +437,7 @@ int lz4_compress(const unsigned char *sr
 exit:
 	return ret;
 }
-EXPORT_SYMBOL_GPL(lz4_compress);
+EXPORT_SYMBOL(lz4_compress);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("LZ4 compressor");
diff -puN lib/lz4/lz4_decompress.c~lib-lz4-correct-the-lz4-license lib/lz4/lz4_decompress.c
--- a/lib/lz4/lz4_decompress.c~lib-lz4-correct-the-lz4-license
+++ a/lib/lz4/lz4_decompress.c
@@ -299,7 +299,7 @@ exit_0:
 	return ret;
 }
 #ifndef STATIC
-EXPORT_SYMBOL_GPL(lz4_decompress);
+EXPORT_SYMBOL(lz4_decompress);
 #endif
 
 int lz4_decompress_unknownoutputsize(const char *src, size_t src_len,
@@ -319,8 +319,8 @@ exit_0:
 	return ret;
 }
 #ifndef STATIC
-EXPORT_SYMBOL_GPL(lz4_decompress_unknownoutputsize);
+EXPORT_SYMBOL(lz4_decompress_unknownoutputsize);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("LZ4 Decompressor");
 #endif
diff -puN lib/lz4/lz4hc_compress.c~lib-lz4-correct-the-lz4-license lib/lz4/lz4hc_compress.c
--- a/lib/lz4/lz4hc_compress.c~lib-lz4-correct-the-lz4-license
+++ a/lib/lz4/lz4hc_compress.c
@@ -533,7 +533,7 @@ int lz4hc_compress(const unsigned char *
 exit:
 	return ret;
 }
-EXPORT_SYMBOL_GPL(lz4hc_compress);
+EXPORT_SYMBOL(lz4hc_compress);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("LZ4HC compressor");
_

Patches currently in -mm which might be from rlaager@wiktel.com are

lib-lz4-correct-the-lz4-license.patch

