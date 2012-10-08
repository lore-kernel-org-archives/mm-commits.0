From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix.patch removed from -mm tree
Date: Mon, 08 Oct 2012 16:18:21 -0700
Message-ID: <20121008231822.48D681E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:44438 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab2JHXSX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 19:18:23 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so538644ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 16:18:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, davem@davemloft.net, gerald.schaefer@de.ibm.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix
has been removed from the -mm tree.  Its filename was
     mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix.patch

This patch was dropped because it was folded into mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix

implement update_mm_cache_pmd() for s390

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Miller <davem@davemloft.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/pgtable.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/s390/include/asm/pgtable.h~mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix
+++ a/arch/s390/include/asm/pgtable.h
@@ -42,6 +42,7 @@ extern void fault_init(void);
  * tables contain all the necessary information.
  */
 #define update_mmu_cache(vma, address, ptep)     do { } while (0)
+#define update_mmu_cache_pmd(vma, address, ptep) do { } while (0)
 
 /*
  * ZERO_PAGE is a global shared page that is always zero; used
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host.patch
rbtree-performance-and-correctness-test.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-fix-tracing-in-free_pcppages_bulk.patch
cma-count-free-cma-pages.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
atomic-implement-generic-atomic_dec_if_positive.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
cma-migrate-mlocked-pages.patch
mm-avoid-section-mismatch-warning-for-memblock_type_name.patch
mm-document-pagehuge-somewhat.patch
mm-memcg-clean-up-mm_match_cgroup-signature.patch
memory-hotplug-suppress-trying-to-free-nonexistent-resource-xxxxxxxxxxxxxxxx-yyyyyyyyyyyyyyyy-warning.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code.patch

