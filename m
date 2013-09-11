From: akpm@linux-foundation.org
Subject: [folded-merged]
 genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix.patch removed
 from -mm tree
Date: Wed, 11 Sep 2013 13:57:02 -0700
Message-ID: <5230d91e.2HO4KWGtrLCFqnsU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab3IKU5D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 16:57:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jy0922.shim@samsung.com, akpm@linux-foundation.org

Subject: [folded-merged] genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,jy0922.shim@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 13:57:02 -0700


The patch titled
     Subject: genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix
has been removed from the -mm tree.  Its filename was
     genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix.patch

This patch was dropped because it was folded into genalloc-fix-overflow-of-ending-address-of-memory-chunk.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix

add comment to struct gen_pool_chunk:end_addr

Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/genalloc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/genalloc.h~genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix include/linux/genalloc.h
--- a/include/linux/genalloc.h~genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix
+++ a/include/linux/genalloc.h
@@ -66,8 +66,8 @@ struct gen_pool_chunk {
 	struct list_head next_chunk;	/* next chunk in pool */
 	atomic_t avail;
 	phys_addr_t phys_addr;		/* physical starting address of memory chunk */
-	unsigned long start_addr;	/* starting address of memory chunk */
-	unsigned long end_addr;		/* ending address of memory chunk */
+	unsigned long start_addr;	/* start address of memory chunk */
+	unsigned long end_addr;		/* end address of memory chunk (inclusive) */
 	unsigned long bits[0];		/* bitmap for allocating memory chunk */
 };
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
block-support-embedded-device-command-line-partition.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too.patch
swap-make-swap-discard-async.patch
swap-make-cluster-allocation-per-cpu.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters.patch
genalloc-fix-overflow-of-ending-address-of-memory-chunk.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages-fix.patch
mm-hotplug-verify-hotplug-memory-range-fix.patch
mm-fix-aio-performance-regression-for-database-caused-by-thp-fix.patch
mm-track-vma-changes-with-vm_softdirty-bit-fix.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix-2.patch
mm-page-writebackc-add-strictlimit-feature-fix.patch
mm-madvisec-madvise_hwpoison-remove-local-ret.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
partitions-efi-use-lba-aware-partition-records-checkpatch-fixes.patch
partitions-efi-check-pmbr-records-starting-lba-checkpatch-fixes.patch
partitions-efi-detect-hybrid-mbrs-checkpatch-fixes.patch
partitions-efi-some-style-cleanups-checkpatch-fixes.patch
block-partitions-efic-consistently-use-pr_foo.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch

