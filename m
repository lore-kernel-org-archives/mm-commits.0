From: akpm@linux-foundation.org
Subject: [folded-merged]
 hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 23 Jun 2014 13:09:19 -0700
Message-ID: <53a8896f.ovK9UW6H1DaN5ADL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaFWUJU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 16:09:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, akpm@linux-foundation.org


The patch titled
     Subject: hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry-checkpatch-fixes.patch

This patch was dropped because it was folded into hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry-checkpatch-fixes

WARNING: Missing a blank line after declarations
#65: FILE: mm/hugetlb.c:2593:
+			swp_entry_t swp_entry = pte_to_swp_entry(entry);
+			if (is_write_migration_entry(swp_entry) && cow) {

total: 0 errors, 1 warnings, 90 lines checked

./patches/hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/hugetlb.c~hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry-checkpatch-fixes mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry-checkpatch-fixes
+++ a/mm/hugetlb.c
@@ -2590,6 +2590,7 @@ int copy_hugetlb_page_range(struct mm_st
 		} else if (unlikely(is_hugetlb_entry_migration(entry) ||
 				    is_hugetlb_entry_hwpoisoned(entry))) {
 			swp_entry_t swp_entry = pte_to_swp_entry(entry);
+
 			if (is_write_migration_entry(swp_entry) && cow) {
 				/*
 				 * COW mappings require pages in both
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep-checkpatch-fixes.patch
shmem-fix-faulting-into-a-hole-while-its-punched-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
ia64-arch-ia64-include-uapi-asm-fcntlh-needs-personalityh.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

