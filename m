From: akpm@linux-foundation.org
Subject: [folded] mmapc-fix-comment-for-__insert_vm_struct-fix.patch removed from -mm tree
Date: Wed, 21 Mar 2012 16:23:06 -0700
Message-ID: <20120321232306.80E3EA0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:49785 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab2CUXXI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Mar 2012 19:23:08 -0400
Received: by mail-we0-f202.google.com with SMTP id x9so83122wej.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Mar 2012 16:23:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, consul.kautuk@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmapc-fix-comment-for-__insert_vm_struct-fix
has been removed from the -mm tree.  Its filename was
     mmapc-fix-comment-for-__insert_vm_struct-fix.patch

This patch was dropped because it was folded into mmapc-fix-comment-for-__insert_vm_struct.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmapc-fix-comment-for-__insert_vm_struct-fix

improve comment layout and text

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kautuk Consul <consul.kautuk@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/mmap.c~mmapc-fix-comment-for-__insert_vm_struct-fix mm/mmap.c
--- a/mm/mmap.c~mmapc-fix-comment-for-__insert_vm_struct-fix
+++ a/mm/mmap.c
@@ -452,9 +452,8 @@ static void vma_link(struct mm_struct *m
 }
 
 /*
- * Helper for vma_adjust in the split_vma insert case:
- * insert vm structure into list and rbtree, but it has
- * already been inserted into prio_tree earlier.
+ * Helper for vma_adjust() in the split_vma insert case: insert a vma into the
+ * mm's list and rbtree.  It has already been inserted into the prio_tree.
  */
 static void __insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode.patch
fs-nameic-fix-warnings-on-32-bit.patch
make-swapin-readahead-skip-over-holes.patch
vmscan-kswapd-carefully-call-compaction.patch
mm-compaction-make-compact_control-order-signed.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
thp-optimize-away-unnecessary-page-table-locking.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch
mm-fix-move-migrate_pages-race-on-task-struct.patch
bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section.patch
hugetlbfs-fix-alignment-of-huge-page-requests.patch
hugetlbfs-return-error-code-when-initializing-module.patch
mmapc-fix-comment-for-__insert_vm_struct.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
memcg-simplify-move_account-check-fix.patch
memcg-use-new-logic-for-page-stat-accounting-fix.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch
mm-memcontrolc-s-stealed-stolen.patch
thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage-fix.patch

