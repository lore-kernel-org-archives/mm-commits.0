From: akpm@linux-foundation.org
Subject: [folded] fs-mpagec-consolidate-code-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 13 Jan 2011 15:26:14 -0800
Message-ID: <201101132326.p0DNQFG7006952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756883Ab1AMX0R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 18:26:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, haishan.bai@gmail.com, shan.hai@windriver.com, mm-commits@vger.kernel.org


The patch titled
     fs-mpagec-consolidate-code-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     fs-mpagec-consolidate-code-checkpatch-fixes.patch

This patch was dropped because it was folded into fs-mpagec-consolidate-code.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs-mpagec-consolidate-code-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space required before the open brace '{'
#65: FILE: fs/mpage.c:63:
+			if (!uptodate){

total: 1 errors, 0 warnings, 68 lines checked

./patches/fs-mpagec-consolidate-code.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Hai Shan <haishan.bai@gmail.com>
Cc: Hai Shan <shan.hai@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/mpage.c~fs-mpagec-consolidate-code-checkpatch-fixes fs/mpage.c
--- a/fs/mpage.c~fs-mpagec-consolidate-code-checkpatch-fixes
+++ a/fs/mpage.c
@@ -60,7 +60,7 @@ static void mpage_end_io(struct bio *bio
 			}
 			unlock_page(page);
 		} else { /* bio_data_dir(bio) == WRITE */
-			if (!uptodate){
+			if (!uptodate) {
 				SetPageError(page);
 				if (page->mapping)
 					set_bit(AS_EIO, &page->mapping->flags);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
writeback-avoid-unnecessary-determine_dirtyable_memory-call-fix.patch
thp-pte-alloc-trans-splitting-fix-checkpatch-fixes.patch
thp-kvm-mmu-transparent-hugepage-support-bisection.patch
thp-khugepaged-make-khugepaged-aware-of-madvise-fix.patch
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

