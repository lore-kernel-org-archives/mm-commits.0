From: akpm@linux-foundation.org
Subject: [folded-merged] mm-oom_reaper-report-success-failure-v6.patch
 removed from -mm tree
Date: Fri, 25 Mar 2016 14:11:57 -0700
Message-ID: <56f5a99d.aIcoSfxBCeH4pq48%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbcCYVL6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2016 17:11:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom_reaper-report-success-failure-v6
has been removed from the -mm tree.  Its filename was
     mm-oom_reaper-report-success-failure-v6.patch

This patch was dropped because it was folded into mm-oom_reaper-report-success-failure.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm-oom_reaper-report-success-failure-v6

Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/oom_kill.c~mm-oom_reaper-report-success-failure-v6 mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_reaper-report-success-failure-v6
+++ a/mm/oom_kill.c
@@ -410,8 +410,6 @@ static DECLARE_WAIT_QUEUE_HEAD(oom_victi
 
 bool oom_killer_disabled __read_mostly;
 
-#define K(x) ((x) << (PAGE_SHIFT-10))
-
 #ifdef CONFIG_MMU
 /*
  * OOM Reaper kernel thread which tries to reap the memory used by the OOM
@@ -421,6 +419,7 @@ static struct task_struct *oom_reaper_th
 static struct task_struct *task_to_reap;
 static DECLARE_WAIT_QUEUE_HEAD(oom_reaper_wait);
 
+#define K(x) ((x) << (PAGE_SHIFT-10))
 static bool __oom_reap_task(struct task_struct *tsk)
 {
 	struct mmu_gather tlb;
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom-introduce-oom-reaper.patch
oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space.patch
mm-oom_reaper-report-success-failure.patch
mm-oom_reaper-implement-oom-victims-queuing.patch
mm-oom_reaper-implement-oom-victims-queuing-v6.patch
oom-oom_reaper-disable-oom_reaper-for-oom_kill_allocating_task.patch
oom-make-oom_reaper-freezable.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch

