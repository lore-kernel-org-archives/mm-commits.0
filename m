From: akpm@linux-foundation.org
Subject: + lib-stringc-introduce-memchr_inv-fix-kernel-doc-for-memchr_inv.patch added to -mm tree
Date: Thu, 25 Aug 2011 17:04:03 -0700
Message-ID: <201108260004.p7Q043Tk021474@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752912Ab1HZAEK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Aug 2011 20:04:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, cl@linux.com, geert@linux-m68k.org


The patch titled
     lib-stringc-introduce-memchr_inv-fix-kernel-doc-for-memchr_inv
has been added to the -mm tree.  Its filename is
     lib-stringc-introduce-memchr_inv-fix-kernel-doc-for-memchr_inv.patch

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
Subject: lib-stringc-introduce-memchr_inv-fix-kernel-doc-for-memchr_inv
From: Akinobu Mita <akinobu.mita@gmail.com>

This fixes kernel-doc for memchr_inv() which is introduced by
lib-stringc-introduce-memchr_inv.patch in mmotm 2011-08-24-14-08

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/string.c~lib-stringc-introduce-memchr_inv-fix-kernel-doc-for-memchr_inv lib/string.c
--- a/lib/string.c~lib-stringc-introduce-memchr_inv-fix-kernel-doc-for-memchr_inv
+++ a/lib/string.c
@@ -769,10 +769,10 @@ static void *check_bytes8(const u8 *star
 }
 
 /**
- * memchr_inv - Find a character in an area of memory.
- * @s: The memory area
- * @c: The byte to search for
- * @n: The size of the area.
+ * memchr_inv - Find an unmatching character in an area of memory.
+ * @start: The memory area
+ * @c: Find a character other than c
+ * @bytes: The size of the area.
  *
  * returns the address of the first character other than @c, or %NULL
  * if the whole buffer contains just @c.
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch
mm-debug-pageallocc-use-plain-__ratelimit-instead-of-printk_ratelimit.patch
lib-stringc-introduce-memchr_inv.patch
lib-stringc-introduce-memchr_inv-fix-kernel-doc-for-memchr_inv.patch
mm-debug-pageallocc-use-memchr_inv.patch
debug-pagealloc-add-support-for-highmem-pages.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch

