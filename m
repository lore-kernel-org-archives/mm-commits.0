From: akpm@linux-foundation.org
Subject: - sched-ymf-typo.patch removed from -mm tree
Date: Mon, 30 Apr 2007 11:48:02 -0700
Message-ID: <200704301848.l3UIm2Gd011804@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946601AbXD3SsL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 14:48:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kernel@kolivas.org, mm-commits@vger.kernel.org


The patch titled
     sched: ymf typo
has been removed from the -mm tree.  Its filename was
     sched-ymf-typo.patch

This patch was dropped because I need to clear the decks

------------------------------------------------------
Subject: sched: ymf typo
From: Con Kolivas <kernel@kolivas.org>

Typo in comment, 1us not 1ms.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~sched-ymf-typo kernel/sched.c
--- a/kernel/sched.c~sched-ymf-typo
+++ a/kernel/sched.c
@@ -3273,7 +3273,7 @@ update_cpu_clock(struct task_struct *p, 
 		/*
 		 * Called from context_switch there should be less than one
 		 * jiffy worth, and not negative/overflow. There should be
-		 * some time banked here so use a nominal 1ms.
+		 * some time banked here so use a nominal 1us.
 		 */
 		if (time_diff > JIFFIES_TO_NS(1) || time_diff < 1)
 			time_diff = 1000;
_

Patches currently in -mm which might be from kernel@kolivas.org are

sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
sched-ymf-typo.patch
sched-implement-staircase-deadline-scheduler-load-weight-fix.patch
sched-increase-ksoftirqd-priority.patch
sched-remove-noninteractive-flag.patch
sched-document-sd-cpu-scheduler.patch
sched-implement-staircase-deadline-scheduler-rework-priomatrix-doc.patch
sched-consolidate-sched_clock-drift-adjustments.patch
sched-consolidate-sched_clock-drift-adjustments-fix.patch
sched-implement-staircase-deadline-scheduler-docupdate.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
