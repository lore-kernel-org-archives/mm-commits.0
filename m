From: akpm@linux-foundation.org
Subject: - sched-implement-staircase-deadline-scheduler-docupdate.patch removed from -mm tree
Date: Mon, 30 Apr 2007 11:48:29 -0700
Message-ID: <200704301848.l3UImTlI011834@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946608AbXD3Ssf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 14:48:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kernel@kolivas.org, mm-commits@vger.kernel.org


The patch titled
     sched: implement staircase deadline scheduler docupdate
has been removed from the -mm tree.  Its filename was
     sched-implement-staircase-deadline-scheduler-docupdate.patch

This patch was dropped because I need to clear the decks

------------------------------------------------------
Subject: sched: implement staircase deadline scheduler docupdate
From: Con Kolivas <kernel@kolivas.org>

Update documentation to reflect higher maximum rr_interval.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/sysctl/kernel.txt~sched-implement-staircase-deadline-scheduler-docupdate Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~sched-implement-staircase-deadline-scheduler-docupdate
+++ a/Documentation/sysctl/kernel.txt
@@ -298,7 +298,7 @@ overall. This value is in milliseconds a
 depends on the number of cpus available at scheduler initialisation
 with a minimum of 8.
 
-Valid values are from 1-100.
+Valid values are from 1-5000.
 
 ==============================================================
 
_

Patches currently in -mm which might be from kernel@kolivas.org are

sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
sched-implement-staircase-deadline-scheduler-docupdate.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
