From: akpm@linux-foundation.org
Subject: [folded] lib-stringc-introduce-memchr_inv-fix-kernel-doc-for-memchr_inv.patch removed from -mm tree
Date: Mon, 31 Oct 2011 16:42:34 -0700
Message-ID: <201110312342.p9VNgYgT002087@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:52387 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab1JaXmp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2011 19:42:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, cl@linux.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-stringc-introduce-memchr_inv-fix-kernel-doc-for-memchr_inv
has been removed from the -mm tree.  Its filename was
     lib-stringc-introduce-memchr_inv-fix-kernel-doc-for-memchr_inv.patch

This patch was dropped because it was folded into lib-stringc-introduce-memchr_inv.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: lib-stringc-introduce-memchr_inv-fix-kernel-doc-for-memchr_inv

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

origin.patch
mm-debug-pageallocc-use-plain-__ratelimit-instead-of-printk_ratelimit.patch
lib-stringc-introduce-memchr_inv.patch
mm-debug-pageallocc-use-memchr_inv.patch
debug-pagealloc-add-support-for-highmem-pages.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
spinlock_debug-print-owner-on-spinlock-lockup.patch

