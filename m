From: akpm@linux-foundation.org
Subject: [folded-merged] mm-hotplug-verify-hotplug-memory-range-fix.patch
 removed from -mm tree
Date: Wed, 11 Sep 2013 13:57:44 -0700
Message-ID: <5230d948.D0//YyNbeM46oXwg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49051 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab3IKU5p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 16:57:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, toshi.kani@hp.com, tangchen@cn.fujitsu.com, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-hotplug-verify-hotplug-memory-range-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,tangchen@cn.fujitsu.com,toshi.kani@hp.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 13:57:44 -0700


The patch titled
     Subject: mm-hotplug-verify-hotplug-memory-range-fix
has been removed from the -mm tree.  Its filename was
     mm-hotplug-verify-hotplug-memory-range-fix.patch

This patch was dropped because it was folded into mm-hotplug-verify-hotplug-memory-range.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hotplug-verify-hotplug-memory-range-fix

avoid printk warnings

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-hotplug-verify-hotplug-memory-range-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-hotplug-verify-hotplug-memory-range-fix
+++ a/mm/memory_hotplug.c
@@ -1079,7 +1079,8 @@ static int check_hotplug_memory_range(u6
 	if ((start_pfn & ~PAGE_SECTION_MASK) ||
 	    (nr_pages % PAGES_PER_SECTION) || (!nr_pages)) {
 		pr_err("Section-unaligned hotplug range: start 0x%llx, size 0x%llx\n",
-				start, size);
+				(unsigned long long)start,
+				(unsigned long long)size);
 		return -EINVAL;
 	}
 
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
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages.patch
mm-hotplug-verify-hotplug-memory-range.patch
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

