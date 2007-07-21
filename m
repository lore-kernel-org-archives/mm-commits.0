From: akpm@linux-foundation.org
Subject: + whitespace-fixes-system-timers.patch added to -mm tree
Date: Fri, 20 Jul 2007 17:19:06 -0700
Message-ID: <200707210019.l6L0J6On023920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59234 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752660AbXGUA1t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 20:27:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     whitespace fixes: system timers
has been added to the -mm tree.  Its filename is
     whitespace-fixes-system-timers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: whitespace fixes: system timers
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/timer.c~whitespace-fixes-system-timers kernel/timer.c
--- a/kernel/timer.c~whitespace-fixes-system-timers
+++ a/kernel/timer.c
@@ -818,7 +818,7 @@ unsigned long next_timer_interrupt(void)
 #endif
 
 /*
- * Called from the timer interrupt handler to charge one tick to the current 
+ * Called from the timer interrupt handler to charge one tick to the current
  * process.  user_tick is 1 if the tick is user time, 0 for system.
  */
 void update_process_times(int user_tick)
_

Patches currently in -mm which might be from dwalker@mvista.com are

whitespace-fixes-time-syscalls.patch
whitespace-fixes-process-accounting.patch
whitespace-fixes-cpuset.patch
whitespace-fixes-relayfs.patch
whitespace-fixes-audit-filtering.patch
whitespace-fixes-dma-channel-allocator.patch
whitespace-fixes-fork.patch
whitespace-fixes-module-loading.patch
whitespace-fixes-panic-handling.patch
whitespace-fixes-capability-syscalls.patch
whitespace-fixes-syscall-auditing.patch
whitespace-fixes-compat-syscalls.patch
whitespace-fixes-system-auditing.patch
whitespace-fixes-execution-domains.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
