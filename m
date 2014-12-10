From: akpm@linux-foundation.org
Subject: [folded-merged]
 kernel-res_counter-remove-the-unused-api-fix-2.patch removed from -mm tree
Date: Wed, 10 Dec 2014 15:13:08 -0800
Message-ID: <5488d384.cCe1TzJs2lSRz4OY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756847AbaLJXNJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:13:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, pebolle@tiscali.nl, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-res_counter-remove-the-unused-api-fix-2
has been removed from the -mm tree.  Its filename was
     kernel-res_counter-remove-the-unused-api-fix-2.patch

This patch was dropped because it was folded into kernel-res_counter-remove-the-unused-api.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: kernel-res_counter-remove-the-unused-api-fix-2

ditch the last remainings of res_counter

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN Documentation/cgroups/memory.txt~kernel-res_counter-remove-the-unused-api-fix-2 Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~kernel-res_counter-remove-the-unused-api-fix-2
+++ a/Documentation/cgroups/memory.txt
@@ -116,16 +116,16 @@ The memory controller is the first contr
 
 2.1. Design
 
-The core of the design is a counter called the res_counter. The res_counter
-tracks the current memory usage and limit of the group of processes associated
-with the controller. Each cgroup has a memory controller specific data
-structure (mem_cgroup) associated with it.
+The core of the design is a counter called the page_counter. The
+page_counter tracks the current memory usage and limit of the group of
+processes associated with the controller. Each cgroup has a memory controller
+specific data structure (mem_cgroup) associated with it.
 
 2.2. Accounting
 
 		+--------------------+
-		|  mem_cgroup     |
-		|  (res_counter)     |
+		|  mem_cgroup        |
+		|  (page_counter)    |
 		+--------------------+
 		 /            ^      \
 		/             |       \
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
slab-print-slabinfo-header-in-seq-show.patch
mm-memcontrol-lockless-page-counters.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch
mm-memcontrol-update-mem_cgroup_page_lruvec-documentation.patch
mm-memcontrol-clarify-migration-where-old-page-is-uncharged.patch
memcg-remove-activate_kmem_mutex.patch
mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup.patch
mm-memcontrol-uncharge-pages-on-swapout.patch
mm-memcontrol-uncharge-pages-on-swapout-fix.patch
mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-inline-memcg-move_lock-locking.patch
mm-memcontrol-dont-pass-a-null-memcg-to-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
memcg-remove-mem_cgroup_reclaimable-check-from-soft-reclaim.patch
memcg-use-generic-slab-iterators-for-showing-slabinfo.patch
mm-memcontrol-shorten-the-page-statistics-update-slowpath.patch
mm-memcontrol-remove-bogus-null-check-after-mem_cgroup_from_task.patch
mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree.patch
mm-memcontrol-drop-bogus-rcu-locking-from-mem_cgroup_same_or_subtree.patch
mm-memcg-fix-potential-undefined-when-for-page-stat-accounting.patch
mm-hugetlb-fix-__unmap_hugepage_range.patch
mm-memcontrol-remove-stale-page_cgroup_lock-comment.patch
mm-embed-the-memcg-pointer-directly-into-struct-page.patch
mm-embed-the-memcg-pointer-directly-into-struct-page-fix.patch
mm-page_cgroup-rename-file-to-mm-swap_cgroupc.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch

