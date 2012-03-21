From: akpm@linux-foundation.org
Subject: [folded] memcg-simplify-move_account-check-fix.patch removed from -mm tree
Date: Wed, 21 Mar 2012 16:24:55 -0700
Message-ID: <20120321232455.4BECFA0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:42128 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab2CUXY5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Mar 2012 19:24:57 -0400
Received: by wejx9 with SMTP id x9so83169wej.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Mar 2012 16:24:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-simplify-move_account-check-fix
has been removed from the -mm tree.  Its filename was
     memcg-simplify-move_account-check-fix.patch

This patch was dropped because it was folded into memcg-simplify-move_account-check.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-simplify-move_account-check-fix



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-simplify-move_account-check-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-simplify-move_account-check-fix
+++ a/mm/memcontrol.c
@@ -1289,6 +1289,7 @@ int mem_cgroup_swappiness(struct mem_cgr
 
 	return memcg->swappiness;
 }
+
 /*
  * memcg->moving_account is used for checking possibility that some thread is
  * calling move_account(). When a thread on CPU-A starts moving pages under
@@ -1303,7 +1304,6 @@ int mem_cgroup_swappiness(struct mem_cgr
  *                                              rcu_read_unlock()
  *         start move here.
  */
-
 static void mem_cgroup_start_move(struct mem_cgroup *memcg)
 {
 	atomic_inc(&memcg->moving_account);
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
memcg-remove-pcg_cache-page_cgroup-flag.patch
memcg-simplify-move_account-check.patch
memcg-use-new-logic-for-page-stat-accounting-fix.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch
mm-memcontrolc-s-stealed-stolen.patch
thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage-fix.patch

