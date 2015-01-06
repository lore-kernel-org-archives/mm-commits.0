From: akpm@linux-foundation.org
Subject: +
 lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch added to
 -mm tree
Date: Tue, 06 Jan 2015 14:15:26 -0800
Message-ID: <54ac5e7e.VeEC2YFj/W50x0HE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43368 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbbAFWP1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 17:15:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix
has been added to the -mm tree.  Its filename is
     lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix

fix kerneldoc

Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/bitmap.c~lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix
+++ a/lib/bitmap.c
@@ -1039,7 +1039,7 @@ EXPORT_SYMBOL(bitmap_onto);
  *	@dst: resulting smaller bitmap
  *	@orig: original larger bitmap
  *	@sz: specified size
- *	@bits: number of bits in each of these bitmaps
+ *	@nbits: number of bits in each of these bitmaps
  *
  * For each bit oldbit in @orig, set bit oldbit mod @sz in @dst.
  * Clear all other bits in @dst.  See further the comment and
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-prevent-endless-growth-of-anon_vma-hierarchy-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

