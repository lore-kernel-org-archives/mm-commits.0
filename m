From: akpm@linux-foundation.org
Subject: + lib-bitmap-fix-typo-in-kerneldoc-for-bitmap_pos_to_ord.patch
 added to -mm tree
Date: Mon, 07 Jul 2014 16:22:23 -0700
Message-ID: <53bb2baf.AvVvVurLouuy9tAt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:46505 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbaGGXWY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 19:22:24 -0400
Received: by mail-qc0-f201.google.com with SMTP id i17so45643qcy.4
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 16:22:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: fix typo in kerneldoc for bitmap_pos_to_ord
has been added to the -mm tree.  Its filename is
     lib-bitmap-fix-typo-in-kerneldoc-for-bitmap_pos_to_ord.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmap-fix-typo-in-kerneldoc-for-bitmap_pos_to_ord.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmap-fix-typo-in-kerneldoc-for-bitmap_pos_to_ord.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib: bitmap: fix typo in kerneldoc for bitmap_pos_to_ord

A few lines above, it was stated that positions for non-set bits are
mapped to -1, which is obviously also what the code does.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/bitmap.c~lib-bitmap-fix-typo-in-kerneldoc-for-bitmap_pos_to_ord lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-fix-typo-in-kerneldoc-for-bitmap_pos_to_ord
+++ a/lib/bitmap.c
@@ -712,7 +712,7 @@ EXPORT_SYMBOL(bitmap_parselist_user);
  *
  * If for example, just bits 4 through 7 are set in @buf, then @pos
  * values 4 through 7 will get mapped to 0 through 3, respectively,
- * and other @pos values will get mapped to 0.  When @pos value 7
+ * and other @pos values will get mapped to -1.  When @pos value 7
  * gets mapped to (returns) @ord value 3 in this example, that means
  * that bit 7 is the 3rd (starting with 0th) set bit in @buf.
  *
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

lib-list_sort_test-return-enomem-when-allocation-fails.patch
lib-list_sort_test-add-extra-corruption-check.patch
lib-list_sort_test-simplify-and-harden-cleanup.patch
lib-list_sortc-limit-number-of-unused-cmp-callbacks.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
lib-bitmap-make-nbits-parameter-of-bitmap_empty-unsigned.patch
lib-bitmap-make-nbits-parameter-of-bitmap_full-unsigned.patch
lib-bitmap-make-nbits-parameter-of-bitmap_equal-unsigned.patch
lib-bitmap-make-nbits-parameter-of-bitmap_complement-unsigned.patch
lib-bitmap-remove-unnecessary-mask-from-bitmap_complement.patch
lib-bitmap-make-nbits-parameter-of-bitmap_andorxorandnot-unsigned.patch
lib-bitmap-make-nbits-parameter-of-bitmap_intersects-unsigned.patch
lib-bitmap-make-nbits-parameter-of-bitmap_subset-unsigned.patch
lib-bitmap-make-nbits-parameter-of-bitmap_weight-unsigned.patch
lib-bitmap-make-the-start-index-of-bitmap_set-unsigned.patch
lib-bitmap-make-the-start-index-of-bitmap_clear-unsigned.patch
lib-bitmap-simplify-bitmap_parselist.patch
lib-bitmap-fix-typo-in-kerneldoc-for-bitmap_pos_to_ord.patch
lib-bitmap-change-parameter-of-bitmap__region-to-unsigned.patch
lib-bitmap-micro-optimize-bitmap_allocate_region.patch
lib-bitmap-add-missing-mask-in-bitmap_shift_right.patch
lib-bitmap-add-missing-mask-in-bitmap_and.patch
lib-bitmap-add-missing-mask-in-bitmap_andnot.patch
checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
linux-next.patch

