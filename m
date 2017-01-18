From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 18 Jan 2017 14:23:43 -0800
Message-ID: <587feaef.qJfVJk+W8BsJaErT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42208 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbdARWXo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2017 17:23:44 -0500
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

 kernel/rcu/tree_exp.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN kernel/rcu/tree_exp.h~linux-next-git-rejects kernel/rcu/tree_exp.h
--- a/kernel/rcu/tree_exp.h~linux-next-git-rejects
+++ a/kernel/rcu/tree_exp.h
@@ -711,14 +711,11 @@ void synchronize_rcu_expedited(void)
 {
 	struct rcu_state *rsp = rcu_state_p;
 
-<<<<<<< HEAD
-=======
 	RCU_LOCKDEP_WARN(lock_is_held(&rcu_bh_lock_map) ||
 			 lock_is_held(&rcu_lock_map) ||
 			 lock_is_held(&rcu_sched_lock_map),
 			 "Illegal synchronize_rcu_expedited() in RCU read-side critical section");
 
->>>>>>> linux-next/akpm-base
 	if (rcu_scheduler_active == RCU_SCHEDULER_INACTIVE)
 		return;
 	_synchronize_rcu_expedited(rsp, sync_rcu_exp_handler);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-respect-foll_force-foll_cow-for-thp-checkpatch-fixes.patch
proc-add-a-schedule-point-in-proc_pid_readdir-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
dax-enable-iostat-for-read-write-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix.patch
mm.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix-fix.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

