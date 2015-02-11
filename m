From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-track-move_lock-state-internally-fix.patch removed from -mm
 tree
Date: Wed, 11 Feb 2015 15:12:39 -0800
Message-ID: <54dbe1e7.6u4Im7Gh6grIiFqH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbbBKXMk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 18:12:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: track move_lock state internally fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-track-move_lock-state-internally-fix.patch

This patch was dropped because it was folded into mm-memcontrol-track-move_lock-state-internally.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: track move_lock state internally fix

Update the !CONFIG_MEMCG page stat dummy API.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-track-move_lock-state-internally-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-track-move_lock-state-internally-fix
+++ a/include/linux/memcontrol.h
@@ -283,14 +283,12 @@ mem_cgroup_print_oom_info(struct mem_cgr
 {
 }
 
-static inline struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page,
-					bool *locked, unsigned long *flags)
+static inline struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page)
 {
 	return NULL;
 }
 
-static inline void mem_cgroup_end_page_stat(struct mem_cgroup *memcg,
-					bool *locked, unsigned long *flags)
+static inline void mem_cgroup_end_page_stat(struct mem_cgroup *memcg)
 {
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
vmscan-force-scan-offline-memory-cgroups.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
memcg-add-build_bug_on-for-string-tables.patch
mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
oom-add-helpers-for-setting-and-clearing-tif_memdie.patch
oom-thaw-the-oom-victim-if-it-is-frozen.patch
pm-convert-printk-to-pr_-equivalent.patch
sysrq-convert-printk-to-pr_-equivalent.patch
oom-pm-make-oom-detection-in-the-freezer-path-raceless.patch
mm-memcontrol-simplify-soft-limit-tree-init-code.patch
mm-memcontrol-consolidate-memory-controller-initialization.patch
mm-memcontrol-consolidate-swap-controller-code.patch
memcg-cleanup-preparation-for-page-table-walk.patch
mincore-apply-page-table-walker-on-do_mincore.patch
mincore-apply-page-table-walker-on-do_mincore-fix.patch
mincore-apply-page-table-walker-on-do_mincore-fix-fix.patch
mm-when-stealing-freepages-also-take-pages-created-by-splitting-buddy-page.patch
mm-always-steal-split-buddies-in-fallback-allocations.patch
mm-more-aggressive-page-stealing-for-unmovable-allocations.patch
vmstat-do-not-use-deferrable-delayed-work-for-vmstat_update.patch
mm-incorporate-read-only-pages-into-transparent-huge-pages.patch
mm-incorporate-read-only-pages-into-transparent-huge-pages-v4.patch

