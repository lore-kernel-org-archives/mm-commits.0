From: akpm@linux-foundation.org
Subject: [folded-merged] mm-make-tlb_flush_pending-global-fix.patch
 removed from -mm tree
Date: Thu, 10 Aug 2017 15:19:08 -0700
Message-ID: <598cdbdc.UgyU7zZEZqwha8Ry%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47900 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753426AbdHJWTJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2017 18:19:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@techsingularity.net, minchan@kernel.org, namit@vmware.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-make-tlb_flush_pending-global-fix
has been removed from the -mm tree.  Its filename was
     mm-make-tlb_flush_pending-global-fix.patch

This patch was dropped because it was folded into mm-make-tlb_flush_pending-global.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-make-tlb_flush_pending-global-fix

remove more ifdefs from world's ugliest printk statement

Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nadav Amit <namit@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/debug.c~mm-make-tlb_flush_pending-global-fix mm/debug.c
--- a/mm/debug.c~mm-make-tlb_flush_pending-global-fix
+++ a/mm/debug.c
@@ -124,9 +124,7 @@ void dump_mm(const struct mm_struct *mm)
 #ifdef CONFIG_NUMA_BALANCING
 		"numa_next_scan %lu numa_scan_offset %lu numa_scan_seq %d\n"
 #endif
-#if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
 		"tlb_flush_pending %d\n"
-#endif
 		"def_flags: %#lx(%pGv)\n",
 
 		mm, mm->mmap, mm->vmacache_seqnum, mm->task_size,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-make-tlb_flush_pending-global.patch
mm-fix-list-corruptions-on-shmem-shrinklist-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch
mm-swap-add-swap-readahead-hit-statistics-fix.patch
add-testcases-for-memset16-32-64-fix.patch
lib-add-test-for-bitmap_parselist-fix.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

