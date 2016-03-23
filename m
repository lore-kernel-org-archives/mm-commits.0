From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch removed
 from -mm tree
Date: Wed, 23 Mar 2016 12:58:49 -0700
Message-ID: <56f2f579.SE8nprxbp6MN+kMn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33015 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbcCWT6u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 15:58:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, ryan.ding@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch

This patch was dropped because it was folded into ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix

remove OCFS2_IOCB_UNALIGNED_IO, per Junxiao Bi

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Ryan Ding <ryan.ding@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/ocfs2/aops.h~ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix fs/ocfs2/aops.h
--- a/fs/ocfs2/aops.h~ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix
+++ a/fs/ocfs2/aops.h
@@ -84,7 +84,6 @@ static inline void ocfs2_iocb_set_rw_loc
 enum ocfs2_iocb_lock_bits {
 	OCFS2_IOCB_RW_LOCK = 0,
 	OCFS2_IOCB_RW_LOCK_LEVEL,
-	OCFS2_IOCB_UNALIGNED_IO,
 	OCFS2_IOCB_NUM_LOCKS
 };
 
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
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue.patch
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

