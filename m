From: akpm@linux-foundation.org
Subject: - time-fix-inconsistent-function-names-in-comments.patch removed from -mm tree
Date: Mon, 05 Nov 2007 21:52:46 -0800
Message-ID: <200711060552.lA65qk7r007363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37282 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753983AbXKFF43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 00:56:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     time: fix inconsistent function names in comments
has been removed from the -mm tree.  Its filename was
     time-fix-inconsistent-function-names-in-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: time: fix inconsistent function names in comments
From: lizf <lizf@cn.fujitsu.com>

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-broadcast.c |    2 +-
 kernel/time/tick-sched.c     |    2 +-
 kernel/timer.c               |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/time/tick-broadcast.c~time-fix-inconsistent-function-names-in-comments kernel/time/tick-broadcast.c
--- a/kernel/time/tick-broadcast.c~time-fix-inconsistent-function-names-in-comments
+++ a/kernel/time/tick-broadcast.c
@@ -508,7 +508,7 @@ static void tick_broadcast_clear_oneshot
 }
 
 /**
- * tick_broadcast_setup_highres - setup the broadcast device for highres
+ * tick_broadcast_setup_oneshot - setup the broadcast device
  */
 void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
diff -puN kernel/time/tick-sched.c~time-fix-inconsistent-function-names-in-comments kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~time-fix-inconsistent-function-names-in-comments
+++ a/kernel/time/tick-sched.c
@@ -321,7 +321,7 @@ ktime_t tick_nohz_get_sleep_length(void)
 }
 
 /**
- * nohz_restart_sched_tick - restart the idle tick from the idle task
+ * tick_nohz_restart_sched_tick - restart the idle tick from the idle task
  *
  * Restart the idle tick when the CPU is woken up from idle
  */
diff -puN kernel/timer.c~time-fix-inconsistent-function-names-in-comments kernel/timer.c
--- a/kernel/timer.c~time-fix-inconsistent-function-names-in-comments
+++ a/kernel/timer.c
@@ -790,7 +790,7 @@ static unsigned long cmp_next_hrtimer_ev
 }
 
 /**
- * next_timer_interrupt - return the jiffy of the next pending timer
+ * get_next_timer_interrupt - return the jiffy of the next pending timer
  * @now: current time (in jiffies)
  */
 unsigned long get_next_timer_interrupt(unsigned long now)
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
drivers-video-ps3fb-fix-memset-size-error.patch
w1-fix-memset-size-error.patch
arm-fix-memset-size-error.patch
powerpc-fix-memset-size-error.patch
git-drm.patch
ia64-fix-memset-size-error.patch
