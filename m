From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch removed from -mm tree
Date: Mon, 08 Oct 2012 15:58:52 -0700
Message-ID: <20121008225853.B645E5C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:38368 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab2JHW64 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 18:58:56 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so215331wib.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 15:58:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, hannes@cmpxchg.org, kosaki.motohiro@gmail.com, minchan@kernel.org, sanbai@taobao.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch

This patch was dropped because it was folded into mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix

tweak comment

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Robin Dong <sanbai@taobao.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/swap.c~mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix mm/swap.c
--- a/mm/swap.c~mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix
+++ a/mm/swap.c
@@ -447,9 +447,8 @@ void mark_page_accessed(struct page *pag
 EXPORT_SYMBOL(mark_page_accessed);
 
 /*
- * Check pagevec space before adding new page into as
- * it will prevent ununiform page status in
- * mark_page_accessed() after __lru_cache_add()
+ * Check the pagevec space before adding a new page into it, to prevent
+ * nonuniform page status in mark_page_accessed() after __lru_cache_add().
  */
 void __lru_cache_add(struct page *page, enum lru_list lru)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix-fix.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-count-free-cma-pages-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix-fix.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
cma-migrate-mlocked-pages-fix.patch
mm-avoid-section-mismatch-warning-for-memblock_type_name-fix.patch
mm-document-pagehuge-somewhat.patch
mm-memcg-clean-up-mm_match_cgroup-signature-fix.patch
memory-hotplug-suppress-trying-to-free-nonexistent-resource-xxxxxxxxxxxxxxxx-yyyyyyyyyyyyyyyy-warning.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix.patch

