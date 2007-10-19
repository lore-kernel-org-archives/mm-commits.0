From: akpm@linux-foundation.org
Subject: - whitespace-fixes-system-timers.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:44:01 -0700
Message-ID: <200710190344.l9J3i1rq013113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36609 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759257AbXJSD40 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     whitespace fixes: system timers
has been removed from the -mm tree.  Its filename was
     whitespace-fixes-system-timers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: whitespace fixes: system timers
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/timer.c~whitespace-fixes-system-timers kernel/timer.c
--- a/kernel/timer.c~whitespace-fixes-system-timers
+++ a/kernel/timer.c
@@ -817,7 +817,7 @@ unsigned long next_timer_interrupt(void)
 #endif
 
 /*
- * Called from the timer interrupt handler to charge one tick to the current 
+ * Called from the timer interrupt handler to charge one tick to the current
  * process.  user_tick is 1 if the tick is user time, 0 for system.
  */
 void update_process_times(int user_tick)
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
