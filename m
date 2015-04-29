From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-meminit-inline-some-helper-functions-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 29 Apr 2015 13:36:41 -0700
Message-ID: <554140d9.foOni7WuUMczaOes%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbbD2Ugm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Apr 2015 16:36:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-meminit-inline-some-helper-functions-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-meminit-inline-some-helper-functions-checkpatch-fixes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-meminit-inline-some-helper-functions-checkpatch-fixes

ERROR: code indent should use tabs where possible
#54: FILE: mm/page_alloc.c:911:
+        defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP)$

WARNING: please, no spaces at the start of a line
#54: FILE: mm/page_alloc.c:911:
+        defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP)$

total: 1 errors, 1 warnings, 102 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/mm-meminit-inline-some-helper-functions.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-meminit-inline-some-helper-functions-checkpatch-fixes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-inline-some-helper-functions-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -908,7 +908,7 @@ void __init __free_pages_bootmem(struct
 }
 
 #if defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID) || \
-        defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP)
+	defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP)
 /* Only safe to use early in boot when initialisation is single-threaded */
 struct __meminitdata mminit_pfnnid_cache global_init_state;
 int __meminit early_pfn_to_nid(unsigned long pfn)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch
maintainers-add-co-maintainer-for-led-subsystem.patch
revert-fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

