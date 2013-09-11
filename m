From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch removed from -mm tree
Date: Wed, 11 Sep 2013 13:54:50 -0700
Message-ID: <5230d89a.gNcstgAgnguIVbdJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49031 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab3IKUyv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 16:54:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, iamjoonsoo.kim@lge.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,iamjoonsoo.kim@lge.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 13:54:50 -0700


The patch titled
     Subject: mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch

This patch was dropped because it was folded into mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix

fix spelling in comment

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix
+++ a/mm/hugetlb.c
@@ -448,12 +448,12 @@ static int vma_has_reserves(struct vm_ar
 	if (vma->vm_flags & VM_NORESERVE) {
 		/*
 		 * This address is already reserved by other process(chg == 0),
-		 * so, we should decreament reserved count. Without
-		 * decreamenting, reserve count is remained after releasing
-		 * inode, because this allocated page will go into page cache
-		 * and is regarded as coming from reserved pool in releasing
-		 * step. Currently, we don't have any other solution to deal
-		 * with this situation properly, so add work-around here.
+		 * so, we should decrement reserved count. Without decrementing,
+		 * reserve count remains after releasing inode, because this
+		 * allocated page will go into page cache and is regarded as
+		 * coming from reserved pool in releasing step.  Currently, we
+		 * don't have any other solution to deal with this situation
+		 * properly, so add work-around here.
 		 */
 		if (vma->vm_flags & VM_MAYSHARE && chg == 0)
 			return 1;
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
vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch
genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix.patch
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

