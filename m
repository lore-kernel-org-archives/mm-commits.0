From: akpm@linux-foundation.org
Subject: [folded-merged]
 ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch removed from -mm
 tree
Date: Wed, 11 Sep 2013 14:07:35 -0700
Message-ID: <5230db97.TETVucy+z4XEMiQ7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab3IKVHg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 17:07:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, davidlohr.bueso@hp.com, akpm@linux-foundation.org

Subject: [folded-merged] ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,davidlohr.bueso@hp.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 14:07:35 -0700


The patch titled
     Subject: ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch

This patch was dropped because it was folded into ipcshm-make-shmctl_nolock-lockless.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes

WARNING: space prohibited between function name and open parenthesis '('
#65: FILE: ipc/shm.c:921:
+		if (copy_shmid_to_user (buf, &tbuf, version))

total: 0 errors, 1 warnings, 54 lines checked

./patches/ipcshm-make-shmctl_nolock-lockless.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/shm.c~ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes ipc/shm.c
--- a/ipc/shm.c~ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes
+++ a/ipc/shm.c
@@ -918,7 +918,7 @@ static int shmctl_nolock(struct ipc_name
 		tbuf.shm_nattch	= shp->shm_nattch;
 		rcu_read_unlock();
 
-		if (copy_shmid_to_user (buf, &tbuf, version))
+		if (copy_shmid_to_user(buf, &tbuf, version))
 			err = -EFAULT;
 		else
 			err = result;
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
partitions-efi-use-lba-aware-partition-records.patch
partitions-efi-check-pmbr-records-starting-lba.patch
partitions-efi-detect-hybrid-mbrs.patch
partitions-efi-some-style-cleanups.patch
block-partitions-efic-consistently-use-pr_foo.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified.patch
ipc-drop-ipcctl_pre_down.patch
ipcshm-make-shmctl_nolock-lockless.patch
drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch

