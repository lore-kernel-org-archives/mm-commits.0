From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch removed from -mm tree
Date: Wed, 11 Sep 2013 13:52:13 -0700
Message-ID: <5230d7fd.w0+Yt1u8EgrEIE4W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab3IKUwO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 16:52:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dave@sr71.net, akpm@linux-foundation.org

Subject: [folded-merged] mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,dave@sr71.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 13:52:13 -0700


The patch titled
     Subject: mm-vmstats-track-tlb-flush-stats-on-up-too-fix
has been removed from the -mm tree.  Its filename was
     mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch

This patch was dropped because it was folded into mm-vmstats-track-tlb-flush-stats-on-up-too.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmstats-track-tlb-flush-stats-on-up-too-fix

Cc: Dave Hansen <dave@sr71.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/tlbflush.h |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN arch/x86/include/asm/tlbflush.h~mm-vmstats-track-tlb-flush-stats-on-up-too-fix arch/x86/include/asm/tlbflush.h
--- a/arch/x86/include/asm/tlbflush.h~mm-vmstats-track-tlb-flush-stats-on-up-too-fix
+++ a/arch/x86/include/asm/tlbflush.h
@@ -85,11 +85,10 @@ static inline void __flush_tlb_one(unsig
 
 #ifndef CONFIG_SMP
 
-/* "_up" is for UniProcessor
+/* "_up" is for UniProcessor.
  *
- * This is a helper for other header functions.  *Not*
- * intended to be called directly.  All global TLB
- * flushes need to either call this, or do the bump the
+ * This is a helper for other header functions.  *Not* intended to be called
+ * directly.  All global TLB flushes need to either call this, or to bump the
  * vm statistics themselves.
  */
 static inline void __flush_tlb_up(void)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
block-support-embedded-device-command-line-partition.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too.patch
swap-make-swap-discard-async-checkpatch-fixes.patch
swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
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

