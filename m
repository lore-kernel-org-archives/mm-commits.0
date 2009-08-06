From: akpm@linux-foundation.org
Subject: [obsolete] slqb-add-declaration-for-kmem_cache_init_late.patch removed from -mm tree
Date: Thu, 06 Aug 2009 16:10:41 -0700
Message-ID: <200908062310.n76NAfK5013734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756432AbZHFXLg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2009 19:11:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     slqb: add declaration for kmem_cache_init_late()
has been removed from the -mm tree.  Its filename was
     slqb-add-declaration-for-kmem_cache_init_late.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slqb: add declaration for kmem_cache_init_late()
From: Wu Fengguang <fengguang.wu@intel.com>

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slqb_def.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/slqb_def.h~slqb-add-declaration-for-kmem_cache_init_late include/linux/slqb_def.h
--- a/include/linux/slqb_def.h~slqb-add-declaration-for-kmem_cache_init_late
+++ a/include/linux/slqb_def.h
@@ -298,4 +298,6 @@ static __always_inline void *kmalloc_nod
 }
 #endif
 
+void __init kmem_cache_init_late(void);
+
 #endif /* _LINUX_SLQB_DEF_H */
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
slqb-add-declaration-for-kmem_cache_init_late.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
mm-clean-up-page_remove_rmap.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
mm-oom-analysis-add-shmem-vmstat.patch
mm-shrink_inactive_list-nr_scan-accounting-fix-fix.patch
mm-vmstat-add-isolate-pages.patch
mm-vmstat-add-isolate-pages-fix.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
mm-count-only-reclaimable-lru-pages-v2.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch

