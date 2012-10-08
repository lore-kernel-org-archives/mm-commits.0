From: akpm@linux-foundation.org
Subject: [folded-dropped] rbtree-performance-and-correctness-test-fix.patch removed from -mm tree
Date: Mon, 08 Oct 2012 16:06:18 -0700
Message-ID: <20121008230619.C4974200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:41839 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab2JHXGW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 19:06:22 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so215526wib.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 16:06:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree-performance-and-correctness-test-fix
has been removed from the -mm tree.  Its filename was
     rbtree-performance-and-correctness-test-fix.patch

This patch was dropped because it was folded into rbtree-performance-and-correctness-test.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rbtree-performance-and-correctness-test-fix

fix printk warning: sparc64 cycles_t is unsigned long

Cc: Michel Lespinasse <walken@google.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/rbtree_test.c~rbtree-performance-and-correctness-test-fix lib/rbtree_test.c
--- a/lib/rbtree_test.c~rbtree-performance-and-correctness-test-fix
+++ a/lib/rbtree_test.c
@@ -104,7 +104,7 @@ static int rbtree_test_init(void)
 	time = time2 - time1;
 
 	time = div_u64(time, PERF_LOOPS);
-	printk(" -> %llu cycles\n", time);
+	printk(" -> %llu cycles\n", (unsigned long long)time);
 
 	for (i = 0; i < CHECK_LOOPS; i++) {
 		init();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host.patch
rbtree-performance-and-correctness-test.patch
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

