From: akpm@linux-foundation.org
Subject: [folded] mm-batch-activate_page-to-reduce-lock-contention-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 13 Jan 2011 15:38:57 -0800
Message-ID: <201101132338.p0DNcvlc007546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693Ab1AMXj2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 18:39:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, shaohua.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     mm-batch-activate_page-to-reduce-lock-contention-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-batch-activate_page-to-reduce-lock-contention-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-batch-activate_page-to-reduce-lock-contention.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-batch-activate_page-to-reduce-lock-contention-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: inline keyword should sit between storage class and type
#181: FILE: mm/swap.c:350:
+static void inline activate_page_drain(int cpu)

total: 1 errors, 0 warnings, 145 lines checked

./patches/mm-batch-activate_page-to-reduce-lock-contention.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swap.c~mm-batch-activate_page-to-reduce-lock-contention-checkpatch-fixes mm/swap.c
--- a/mm/swap.c~mm-batch-activate_page-to-reduce-lock-contention-checkpatch-fixes
+++ a/mm/swap.c
@@ -347,7 +347,7 @@ int putback_active_lru_page(struct zone 
 }
 
 #else
-static void inline activate_page_drain(int cpu)
+static inline void activate_page_drain(int cpu)
 {
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
mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common.patch
brk-fix-min_brk-lower-bound-computation-for-compat_brk.patch
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists.patch
mm-dmapoolc-use-task_uninterruptible-in-dma_pool_alloc.patch
hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment.patch
mm-fix-migration-hangs-on-anon_vma-lock.patch
mm-page_allocc-dont-cache-current-in-a-local.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch

