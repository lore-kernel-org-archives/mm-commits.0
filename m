From: akpm@linux-foundation.org
Subject: [folded-merged]
 arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch removed
 from -mm tree
Date: Thu, 04 Jun 2020 16:09:02 -0700
Message-ID: <20200604230902.4eKLCJhGI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgFDXJE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:09:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ira.weiny@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch

This patch was dropped because it was folded into arch-kmap_atomic-consolidate-duplicate-code.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#289: FILE: arch/nds32/mm/highmem.c:35:
+EXPORT_SYMBOL(kmap_atomic_high);

total: 0 errors, 1 warnings, 353 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/arch-kmap_atomic-consolidate-duplicate-code.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nds32/mm/highmem.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/nds32/mm/highmem.c~arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes
+++ a/arch/nds32/mm/highmem.c
@@ -31,7 +31,6 @@ void *kmap_atomic_high(struct page *page
 	__nds32__isb();
 	return (void *)vaddr;
 }
-
 EXPORT_SYMBOL(kmap_atomic_high);
 
 void __kunmap_atomic(void *kvaddr)
@@ -48,5 +47,4 @@ void __kunmap_atomic(void *kvaddr)
 	pagefault_enable();
 	preempt_enable();
 }
-
 EXPORT_SYMBOL(__kunmap_atomic);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-kmap_atomic-consolidate-duplicate-code.patch
arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
kmap-consolidate-kmap_prot-definitions-checkpatch-fixes.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
lib-test-get_count_order-long-in-test_bitopsc-fix.patch
seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-pre.patch
linux-next-rejects.patch
linux-next-post.patch
kernel-add-panic_on_taint-fix.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix.patch
mmap-locking-api-rename-mmap_sem-to-mmap_lock-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
maccess-unify-the-probe-kernel-arch-hooks-fix.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
sh-convert-ins-outs-macros-to-inline-functions-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
