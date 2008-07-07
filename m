From: akpm@linux-foundation.org
Subject: - delay-accounting-maintainer-update.patch removed from -mm tree
Date: Sun, 06 Jul 2008 20:03:20 -0700
Message-ID: <200807070303.m6733KX1004640@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753779AbYGGDJt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:09:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, nagar1234@in.ibm.com, nagar@watson.ibm.com, mm-commits@vger.kernel.org


The patch titled
     delay accounting: maintainer update
has been removed from the -mm tree.  Its filename was
     delay-accounting-maintainer-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: delay accounting: maintainer update
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Update the delay accounting and taskstats maintainer to Balbir Singh.
I spoke to Shailabh and he is now busy with other things.

Cc: Shailabh Nagar <nagar1234@in.ibm.com>
Cc: Shailabh Nagar <nagar@watson.ibm.com>
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN MAINTAINERS~delay-accounting-maintainer-update MAINTAINERS
--- a/MAINTAINERS~delay-accounting-maintainer-update
+++ a/MAINTAINERS
@@ -3199,8 +3199,8 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 
 PER-TASK DELAY ACCOUNTING
-P:	Shailabh Nagar
-M:	nagar@watson.ibm.com
+P:	Balbir Singh
+M:	balbir@linux.vnet.ibm.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
@@ -3902,8 +3902,8 @@ M:	hch@infradead.org
 S:	Maintained
 
 TASKSTATS STATISTICS INTERFACE
-P:	Shailabh Nagar
-M:	nagar@watson.ibm.com
+P:	Balbir Singh
+M:	balbir@linux.vnet.ibm.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

linux-next.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
mark-res_counter_charge_locked-with-__must_check.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-setup-the-memrlimit-controller-memrlimit-correct-mremap-and-move_vma-accounting.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-mmap_sem-deadlock.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-sleep-inside-sleeplock-in-mm_update_next_owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memrlimit-improve-fork-and-error-handling.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback-update.patch
distinct-tgid-tid-i-o-statistics.patch
per-task-delay-accounting-add-memory-reclaim-delay.patch
per-task-delay-accounting-update-document-and-getdelaysc-for-memory-reclaim.patch
gcov-architecture-specific-compile-flag-adjustments-x86_64-fix.patch

