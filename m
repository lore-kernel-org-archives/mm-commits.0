From: akpm@linux-foundation.org
Subject: [folded] scatterlist-new-helper-functions-update-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 19 Jan 2011 13:05:17 -0800
Message-ID: <201101192105.p0JL5HNp003047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754525Ab1ASVFU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Jan 2011 16:05:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, maximlevitsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     scatterlist-new-helper-functions-update-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     scatterlist-new-helper-functions-update-checkpatch-fixes.patch

This patch was dropped because it was folded into scatterlist-new-helper-functions.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scatterlist-new-helper-functions-update-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: please, no space before tabs
#27: FILE: lib/scatterlist.c:44:
+ * @consumed: ^IHow much bytes to advance$

WARNING: please, no space before tabs
#52: FILE: lib/scatterlist.c:95:
+ * @sg: ^IThe current sg entry$

WARNING: please, no space before tabs
#73: FILE: lib/scatterlist.c:624:
+ * @buffer: ^ILinear kernel buffer to compare with$

total: 0 errors, 3 warnings, 86 lines checked

./patches/scatterlist-new-helper-functions-update.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/scatterlist.c~scatterlist-new-helper-functions-update-checkpatch-fixes lib/scatterlist.c
--- a/lib/scatterlist.c~scatterlist-new-helper-functions-update-checkpatch-fixes
+++ a/lib/scatterlist.c
@@ -41,7 +41,7 @@ EXPORT_SYMBOL(sg_next);
 /**
  * sg_advance - advance scatterlist by 'consumed' bytes
  * @sg:		The current sg entry
- * @consumed: 	How much bytes to advance
+ * @consumed:	How much bytes to advance
  */
 struct scatterlist *sg_advance(struct scatterlist *sg, int consumed)
 {
@@ -92,7 +92,7 @@ EXPORT_SYMBOL(sg_nents);
 
 /**
  * sg_total_len - calculate total length of scatterlist
- * @sg: 	The current sg entry
+ * @sg: The current sg entry
  *
  * Dynamically calculate total number of bytes in an scatterlist
  * based on assumption that last entry is correctly marked by sg_mark_end
@@ -621,7 +621,7 @@ EXPORT_SYMBOL(sg_copy_to_buffer);
  * to a kernel ram buffer
  *
  * @sg:		The current sg entry
- * @buffer: 	Linear kernel buffer to compare with
+ * @buffer:	Linear kernel buffer to compare with
  * @len:	Length of that buffer
  *
  * Returns 0 if equal and memcmp compliant result otherwise
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix.patch
fs-direct-ioc-dont-try-to-allocate-more-than-bio_max_pages-in-a-bio-fix.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

