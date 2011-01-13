From: akpm@linux-foundation.org
Subject: [folded] memcg-document-cgroup-dirty-memory-interfaces-fix.patch removed from -mm tree
Date: Thu, 13 Jan 2011 15:39:22 -0800
Message-ID: <201101132339.p0DNdMgI007565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187Ab1AMXkW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 18:40:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, gthelen@google.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@


The patch titled
     memcg-document-cgroup-dirty-memory-interfaces-fix
has been removed from the -mm tree.  Its filename was
     memcg-document-cgroup-dirty-memory-interfaces-fix.patch

This patch was dropped because it was folded into memcg-document-cgroup-dirty-memory-interfaces.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-document-cgroup-dirty-memory-interfaces-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix use_hierarchy description

Cc: Andrea Righi <arighi@develer.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Greg Thelen <gthelen@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-document-cgroup-dirty-memory-interfaces-fix Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-document-cgroup-dirty-memory-interfaces-fix
+++ a/Documentation/cgroups/memory.txt
@@ -520,11 +520,12 @@ When use_hierarchy=0, each cgroup has di
 System-wide dirty limits are also consulted.  Dirty memory consumption is
 checked against both system-wide and per-cgroup dirty limits.
 
-The current implementation does enforce per-cgroup dirty limits when
+The current implementation does not enforce per-cgroup dirty limits when
 use_hierarchy=1.  System-wide dirty limits are used for processes in such
-cgroups.  Attempts to read memory.dirty_* files return the system-wide values.
-Writes to the memory.dirty_* files return error.  An enhanced implementation is
-needed to check the chain of parents to ensure that no dirty limit is exceeded.
+cgroups.  Attempts to read memory.dirty_* files return the system-wide
+values.  Writes to the memory.dirty_* files return error.  An enhanced
+implementation is needed to check the chain of parents to ensure that no
+dirty limit is exceeded.
 
 6. Hierarchy support
 
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
memcg-document-cgroup-dirty-memory-interfaces.patch

