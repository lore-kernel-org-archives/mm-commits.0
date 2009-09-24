From: akpm@linux-foundation.org
Subject: + sched-fix-htmldocs-schedc.patch added to -mm tree
Date: Thu, 24 Sep 2009 15:27:01 -0700
Message-ID: <200909242227.n8OMR1ue017448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573AbZIXW2m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 18:28:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@kernel.org, jaswinderrajput@gmail.com, mingo@elte.hu


The patch titled
     sched: fix htmldocs sched.c
has been added to the -mm tree.  Its filename is
     sched-fix-htmldocs-schedc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
mm-includecheck-fix-vmallocc.patch
fs-includecheck-fix-proc-kcorec.patch
video-includecheck-fix-msm-mddic.patch
video-includecheck-fix-da8xx-fbc.patch
mtd-nand-fix-htmldocs-warnings.patch
sched-fix-htmldocs-schedc.patch

