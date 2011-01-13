From: akpm@linux-foundation.org
Subject: [folded] thp-khugepaged-make-khugepaged-aware-of-madvise-fix.patch removed from -mm tree
Date: Thu, 13 Jan 2011 15:34:26 -0800
Message-ID: <201101132334.p0DNYQIP007347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480Ab1AMXeh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 18:34:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp-khugepaged-make-khugepaged-aware-of-madvise-fix
has been removed from the -mm tree.  Its filename was
     thp-khugepaged-make-khugepaged-aware-of-madvise-fix.patch

This patch was dropped because it was folded into thp-khugepaged-make-khugepaged-aware-of-madvise.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp-khugepaged-make-khugepaged-aware-of-madvise-fix
From: Andrew Morton <akpm@linux-foundation.org>

tweak comment.  It's still incomprehensible though ;)

Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/huge_memory.c~thp-khugepaged-make-khugepaged-aware-of-madvise-fix mm/huge_memory.c
--- a/mm/huge_memory.c~thp-khugepaged-make-khugepaged-aware-of-madvise-fix
+++ a/mm/huge_memory.c
@@ -1426,10 +1426,9 @@ int hugepage_madvise(struct vm_area_stru
 		*vm_flags &= ~VM_HUGEPAGE;
 		*vm_flags |= VM_NOHUGEPAGE;
 		/*
-		 * Setting VM_NOHUGEPAGE will prevent khugepaged to
-		 * scan this vma even if we leave the mm registered in
-		 * khugepaged if it got registered before
-		 * VM_NOHUGEPAGE was set.
+		 * Setting VM_NOHUGEPAGE will prevent khugepaged from scanning
+		 * this vma even if we leave the mm registered in khugepaged if
+		 * it got registered before VM_NOHUGEPAGE was set.
 		 */
 		break;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time.patch
writeback-avoid-unnecessary-determine_dirtyable_memory-call.patch
thp-pte-alloc-trans-splitting.patch
thp-kvm-mmu-transparent-hugepage-support.patch
thp-khugepaged-make-khugepaged-aware-of-madvise.patch
mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration-fix.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common-fix.patch
brk-fix-min_brk-lower-bound-computation-for-compat_brk-fix.patch
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-checkpatch-fixes.patch
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-fix.patch
mm-dmapoolc-use-task_uninterruptible-in-dma_pool_alloc.patch
hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix.patch
mm-fix-migration-hangs-on-anon_vma-lock-checkpatch-fixes.patch
mm-page_allocc-dont-cache-current-in-a-local.patch
mm-batch-activate_page-to-reduce-lock-contention-checkpatch-fixes.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch

