From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
 removed from -mm tree
Date: Wed, 11 Sep 2013 14:02:49 -0700
Message-ID: <5230da79.XcvBy056HpmTKp4h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab3IKVCu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 17:02:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, guz.fnst@cn.fujitsu.com, akpm@linux-foundation.org

Subject: [folded-merged] lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,guz.fnst@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 14:02:49 -0700


The patch titled
     Subject: lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch

This patch was dropped because it was folded into lib-crc32-update-the-comments-of-crc32_bele_generic.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes

WARNING: please, no space before tabs
#20: FILE: lib/crc32.c:135:
+ * ^I^I^ICRC32/CRC32C$

WARNING: line over 80 characters
#24: FILE: lib/crc32.c:137:
+ *	other uses, or the previous crc32/crc32c value if computing incrementally.

total: 0 errors, 2 warnings, 32 lines checked

./patches/lib-crc32-update-the-comments-of-crc32_bele_generic.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc32.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/crc32.c~lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes lib/crc32.c
--- a/lib/crc32.c~lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes
+++ a/lib/crc32.c
@@ -132,9 +132,9 @@ crc32_body(u32 crc, unsigned char const
 
 /**
  * crc32_le_generic() - Calculate bitwise little-endian Ethernet AUTODIN II
- * 			CRC32/CRC32C
- * @crc: seed value for computation.  ~0 for Ethernet, sometimes 0 for
- *	other uses, or the previous crc32/crc32c value if computing incrementally.
+ *			CRC32/CRC32C
+ * @crc: seed value for computation.  ~0 for Ethernet, sometimes 0 for other
+ *	 uses, or the previous crc32/crc32c value if computing incrementally.
  * @p: pointer to buffer over which CRC32/CRC32C is run
  * @len: length of buffer @p
  * @tab: little-endian Ethernet table
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
mm-fix-aio-performance-regression-for-database-caused-by-thp.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page.patch
mm-vmscan-fix-do_try_to_free_pages-livelock.patch
mm-page-writebackc-add-strictlimit-feature.patch
mm-madvisec-madvise_hwpoison-remove-local-ret.patch
lib-crc32-update-the-comments-of-crc32_bele_generic.patch
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

