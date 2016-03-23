From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 23 Mar 2016 10:40:03 -0700
Message-ID: <56f2d4f3.sFAnqj2EeB8U++Sz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351AbcCWRkF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:40:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/ctree.h   |    9 ---------
 fs/btrfs/disk-io.c |    5 -----
 2 files changed, 14 deletions(-)

diff -puN fs/btrfs/ctree.h~linux-next-git-rejects fs/btrfs/ctree.h
--- a/fs/btrfs/ctree.h~linux-next-git-rejects
+++ a/fs/btrfs/ctree.h
@@ -2200,21 +2200,12 @@ struct btrfs_ioctl_defrag_range_args {
  *
  * - balance status item
  *   (BTRFS_BALANCE_OBJECTID, BTRFS_TEMPORARY_ITEM_KEY, 0)
-<<<<<<< HEAD
  */
 #define BTRFS_TEMPORARY_ITEM_KEY	248
 
 /*
  * Obsolete name, see BTRFS_PERSISTENT_ITEM_KEY
  */
-=======
- */
-#define BTRFS_TEMPORARY_ITEM_KEY	248
-
-/*
- * Obsolete name, see BTRFS_PERSISTENT_ITEM_KEY
- */
->>>>>>> linux-next/akpm-base
 #define BTRFS_DEV_STATS_KEY		249
 
 /*
diff -puN fs/btrfs/disk-io.c~linux-next-git-rejects fs/btrfs/disk-io.c
--- a/fs/btrfs/disk-io.c~linux-next-git-rejects
+++ a/fs/btrfs/disk-io.c
@@ -670,12 +670,7 @@ static int btree_readpage_end_io_hook(st
 				       eb, found_level);
 
 	ret = csum_tree_block(fs_info, eb, 1);
-<<<<<<< HEAD
-	if (ret) {
-		ret = -EIO;
-=======
 	if (ret)
->>>>>>> linux-next/akpm-base
 		goto err;
 
 	/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
sched-add-schedule_timeout_idle.patch
drivers-input-eliminate-input_compat_test-macro.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-code-clean-up-for-direct-io-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
mm.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

