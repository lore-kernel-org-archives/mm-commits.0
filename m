From: akpm@linux-foundation.org
Subject: [merged] sched-fix-htmldocs-schedc.patch removed from -mm tree
Date: Thu, 15 Oct 2009 11:43:48 -0700
Message-ID: <200910151843.n9FIhmBh024010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935318AbZJOSph (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 14:45:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaswinder@kernel.org, jaswinderrajput@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     sched: fix htmldocs sched.c
has been removed from the -mm tree.  Its filename was
     sched-fix-htmldocs-schedc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sched: fix htmldocs sched.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

fix the following htmldocs warnings:

  Warning(kernel/sched.c:685): No description found for parameter 'cpu'
  Warning(kernel/sched.c:3676): No description found for parameter 'sd'

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/sched.c~sched-fix-htmldocs-schedc kernel/sched.c
--- a/kernel/sched.c~sched-fix-htmldocs-schedc
+++ a/kernel/sched.c
@@ -676,6 +676,7 @@ inline void update_rq_clock(struct rq *r
 
 /**
  * runqueue_is_locked
+ * @cpu: the processor in question.
  *
  * Returns true if the current cpu runqueue is locked.
  * This interface allows printk to be called with the runqueue lock
@@ -3658,6 +3659,7 @@ static void update_group_power(struct sc
 
 /**
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
+ * @sd: The sched_domain whose statistics are to be updated.
  * @group: sched_group whose statistics are to be updated.
  * @this_cpu: Cpu for which load balance is currently performed.
  * @idle: Idle status of this_cpu
_

Patches currently in -mm which might be from jaswinder@kernel.org are

linux-next.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
xtensa-includecheck-fix-vectorss.patch

