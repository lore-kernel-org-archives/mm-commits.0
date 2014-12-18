From: akpm@linux-foundation.org
Subject: +
 lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch added to
 -mm tree
Date: Thu, 18 Dec 2014 14:30:48 -0800
Message-ID: <54935598.4RX0rvRWC3a56aG4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaLRWat (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Dec 2014 17:30:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch

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
Subject: lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes

WARNING: please, no space before tabs
#38: FILE: lib/bitmap.c:1011:
+^Iunsigned int n, m;       ^I/* same meaning as in above comment */$

total: 0 errors, 1 warnings, 19 lines checked

./patches/lib-bitmap-update-bitmap_onto-to-unsigned.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/bitmap.c~lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes
+++ a/lib/bitmap.c
@@ -1008,7 +1008,7 @@ EXPORT_SYMBOL(bitmap_bitremap);
 void bitmap_onto(unsigned long *dst, const unsigned long *orig,
 			const unsigned long *relmap, unsigned int bits)
 {
-	unsigned int n, m;       	/* same meaning as in above comment */
+	unsigned int n, m;	/* same meaning as in above comment */
 
 	if (dst == orig)	/* following doesn't handle inplace mappings */
 		return;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation.patch
mailmap-update-akpm-osdlorg.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
tools-testing-selftests-makefile-alphasort-the-targets-list.patch
mm-prevent-endless-growth-of-anon_vma-hierarchy-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

