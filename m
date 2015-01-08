From: akpm@linux-foundation.org
Subject: +
 livepatching-handle-ancient-compilers-with-more-grace-checkpatch-fixes.patch added to -mm tree
Date: Wed, 07 Jan 2015 16:21:45 -0800
Message-ID: <54adcd99.O92Y6TObtovfvCbX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbbAHAVq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2015 19:21:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: livepatching-handle-ancient-compilers-with-more-grace-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     livepatching-handle-ancient-compilers-with-more-grace-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/livepatching-handle-ancient-compilers-with-more-grace-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/livepatching-handle-ancient-compilers-with-more-grace-checkpatch-fixes.patch

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
Subject: livepatching-handle-ancient-compilers-with-more-grace-checkpatch-fixes

ERROR: code indent should use tabs where possible
#32: FILE: arch/x86/include/asm/livepatch.h:31:
+^I        return 1;$

ERROR: code indent should use tabs where possible
#34: FILE: arch/x86/include/asm/livepatch.h:33:
+^I        return 0;$

total: 2 errors, 0 warnings, 26 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/livepatching-handle-ancient-compilers-with-more-grace.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/livepatch.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/include/asm/livepatch.h~livepatching-handle-ancient-compilers-with-more-grace-checkpatch-fixes arch/x86/include/asm/livepatch.h
--- a/arch/x86/include/asm/livepatch.h~livepatching-handle-ancient-compilers-with-more-grace-checkpatch-fixes
+++ a/arch/x86/include/asm/livepatch.h
@@ -28,9 +28,9 @@
 static inline int klp_check_compiler_support(void)
 {
 #ifndef CC_USING_FENTRY
-	        return 1;
+	return 1;
 #endif
-	        return 0;
+	return 0;
 }
 extern int klp_write_module_reloc(struct module *mod, unsigned long type,
 				  unsigned long loc, unsigned long value);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-prevent-endless-growth-of-anon_vma-hierarchy-fix.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-change-meminfo-cached-calculation-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
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
livepatching-handle-ancient-compilers-with-more-grace-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

