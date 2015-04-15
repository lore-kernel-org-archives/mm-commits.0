From: akpm@linux-foundation.org
Subject: [merged] mm-cma-allocation-trigger-fix.patch removed from -mm
 tree
Date: Wed, 15 Apr 2015 12:09:27 -0700
Message-ID: <552eb767.7MXRecImPz4Cx1iD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726AbbDOTJ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:09:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, konrad.wilk@oracle.com, lauraa@codeaurora.org, m.szyprowski@samsung.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-allocation-trigger-fix
has been removed from the -mm tree.  Its filename was
     mm-cma-allocation-trigger-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-cma-allocation-trigger-fix

s/CONFIG_CMA_ALIGNMENT/0/, per Joonsoo

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/cma_debug.c~mm-cma-allocation-trigger-fix mm/cma_debug.c
--- a/mm/cma_debug.c~mm-cma-allocation-trigger-fix
+++ a/mm/cma_debug.c
@@ -103,7 +103,7 @@ static int cma_alloc_mem(struct cma *cma
 	if (!mem)
 		return -ENOMEM;
 
-	p = cma_alloc(cma, count, CONFIG_CMA_ALIGNMENT);
+	p = cma_alloc(cma, count, 0);
 	if (!p) {
 		kfree(mem);
 		return -ENOMEM;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-mempool-do-not-allow-atomic-resizing.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
document-interaction-between-compaction-and-the-unevictable-lru-fix.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-mmapc-use-while-instead-of-ifgoto-fix.patch
mm-hugetlb-introduce-pagehugeactive-flag-fix.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch
mm-memblock-add-debug-output-for-the-memblock_add-fix.patch
mm-uninline-and-cleanup-page-mapping-related-helpers-checkpatch-fixes.patch
mm-cma-add-functions-to-get-region-pages-counters-fix.patch
mm-cma_debugc-remove-blank-lines-before-define_simple_attribute.patch
mm-memory-print-also-a_ops-readpage-in-print_bad_pte-fix.patch
mm-compactionc-fix-suitable_migration_target-unused-warning.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
zsmalloc-support-compaction-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
lib-find__bit-reimplementation-fix.patch
checkpatch-match-more-world-writable-permissions-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kernel-forkc-avoid-division-by-zero-fix.patch
kernel-forkc-avoid-division-by-zero-fix-fix.patch
doc-sysctl-kerneltxt-document-threads-max-fix.patch
mm-rcu-protected-get_mm_exe_file-fix-2.patch
affs-kstrdup-memory-handling-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
linux-next-rejects.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
documentation-spi-spidev_testc-fix-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

