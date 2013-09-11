From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-sparse-introduce-alloc_usemap_and_memmap-fix.patch removed from -mm tree
Date: Wed, 11 Sep 2013 14:01:30 -0700
Message-ID: <5230da2a.z2klQSQBQqQuQJvv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab3IKVBb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 17:01:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, liwanp@linux.vnet.ibm.com

Subject: [folded-merged] mm-sparse-introduce-alloc_usemap_and_memmap-fix.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 14:01:30 -0700


The patch titled
     Subject: mm/sparse: introduce alloc_usemap_and_memmap fix
has been removed from the -mm tree.  Its filename was
     mm-sparse-introduce-alloc_usemap_and_memmap-fix.patch

This patch was dropped because it was folded into mm-sparse-introduce-alloc_usemap_and_memmap.patch

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/sparse: introduce alloc_usemap_and_memmap fix

Fix Section mismatch in reference from the function alloc_usemap_and_memmap()
to the function .init.text:sparse_early_usemaps_alloc_node()

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/sparse.c~mm-sparse-introduce-alloc_usemap_and_memmap-fix mm/sparse.c
--- a/mm/sparse.c~mm-sparse-introduce-alloc_usemap_and_memmap-fix
+++ a/mm/sparse.c
@@ -473,7 +473,7 @@ void __attribute__((weak)) __meminit vme
  *  @map: usemap_map for pageblock flags or mmap_map for vmemmap
  *  @use_map: true if memory allocated for pageblock flags, otherwise false
  */
-static void alloc_usemap_and_memmap(unsigned long **map, bool use_map)
+static void __init alloc_usemap_and_memmap(unsigned long **map, bool use_map)
 {
 	unsigned long pnum;
 	unsigned long map_count;
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
mm-zswapc-get-swapper-address_space-by-using-macro.patch
mm-fix-potential-null-pointer-dereference.patch
mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch
mm-hugetlb-trivial-commenting-fix.patch
mm-hugetlb-clean-up-alloc_huge_page.patch
mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free.patch
mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages.patch
mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch
mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch
mm-hugetlb-remove-decrement_hugepage_resv_vma.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
mm-vmalloc-remove-useless-variable-in-vmap_block.patch
mm-vmalloc-use-well-defined-find_last_bit-func.patch
mm-hotplug-verify-hotplug-memory-range.patch
mm-hotplug-remove-stop_machine-from-try_offline_node.patch
mm-hugetlb-protect-reserved-pages-when-soft-offlining-a-hugepage.patch
mm-hugetlb-change-variable-name-reservations-to-resv.patch
mm-hugetlb-fix-subpool-accounting-handling.patch
mm-hugetlb-remove-useless-check-about-mapping-type.patch
mm-hugetlb-grab-a-page_table_lock-after-page_cache_release.patch
mm-hugetlb-return-a-reserved-page-to-a-reserved-pool-if-failed.patch
mm-migrate-make-core-migration-code-aware-of-hugepage.patch
mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page.patch
migrate-add-hugepage-migration-code-to-migrate_pages.patch
mm-migrate-add-hugepage-migration-code-to-move_pages.patch
mm-mbind-add-hugepage-migration-code-to-mbind.patch
mm-migrate-remove-vm_hugetlb-from-vma-flag-check-in-vma_migratable.patch
mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage.patch
mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch
mm-mempolicy-rename-check_range-to-queue_pages_range.patch
mm-sparse-introduce-alloc_usemap_and_memmap.patch
mm-sparse-introduce-alloc_usemap_and_memmap-fix-2.patch
mm-sparse-introduce-alloc_usemap_and_memmap-fix-3.patch
mm-writeback-make-writeback_inodes_wb-static.patch
mm-vmalloc-use-wrapper-function-get_vm_area_size-to-caculate-size-of-vm-area.patch
hwpoison-always-unset-migrate_isolate-before-returning-from-soft_offline_page.patch
mm-hwpoison-fix-loss-of-pg_dirty-for-errors-on-mlocked-pages.patch
mm-hwpoison-dont-need-to-hold-compound-lock-for-hugetlbfs-page.patch
mm-hwpoison-fix-race-against-poison-thp.patch
mm-hwpoison-replace-atomic_long_sub-with-atomic_long_dec.patch
mm-hwpoison-dont-set-migration-type-twice-to-avoid-holding-heavily-contend-zone-lock.patch
mm-hwpoison-drop-forward-reference-declarations-__soft_offline_page.patch
mm-hwpoison-add-to-madvise_hwpoison.patch
mm-hwpoisonc-fix-held-reference-count-after-unpoisoning-empty-zero-page.patch
mm-hwpoison-injectc-change-permission-of-corrupt-pfn-unpoison-pfn-to-0200.patch
mm-memory-failurec-fix-bug-triggered-by-unpoisoning-empty-zero-page.patch
mm-hwpoison-fix-return-value-of-madvise_hwpoison.patch
mm-madvisec-madvise_hwpoison-remove-local-ret.patch

