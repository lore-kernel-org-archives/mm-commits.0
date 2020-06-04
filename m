From: akpm@linux-foundation.org
Subject: [folded-merged]
 =?US-ASCII?Q?mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-ch?=
 =?US-ASCII?Q?eckpatch-fixes.patch?= removed from -mm tree
Date: Thu, 04 Jun 2020 16:20:35 -0700
Message-ID: <20200604232035.wXQMb5QJG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgFDXUh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:20:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ethp@qq.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com


The patch titled
     Subject: mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-hugetlb-fix-a-typo-in-comment-manitained-maintained.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes

WARNING: line over 80 characters
#65: FILE: mm/hugetlb.c:4469:
+	 * an active hugepage in pagecache. This goto expects the 2nd page fault,

total: 0 errors, 1 warnings, 48 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Ethon Paul <ethp@qq.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes
+++ a/mm/hugetlb.c
@@ -4580,9 +4580,9 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	/*
 	 * entry could be a migration/hwpoison entry at this point, so this
 	 * check prevents the kernel from going below assuming that we have
-	 * an active hugepage in pagecache. This goto expects the 2nd page fault,
-	 * and is_hugetlb_entry_(migration|hwpoisoned) check will properly
-	 * handle it.
+	 * an active hugepage in pagecache. This goto expects the 2nd page
+	 * fault, and is_hugetlb_entry_(migration|hwpoisoned) check will
+	 * properly handle it.
 	 */
 	if (!pte_present(entry))
 		goto out_mutex;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hugetlb-fix-a-typo-in-comment-manitained-maintained.patch
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
