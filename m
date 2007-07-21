From: akpm@linux-foundation.org
Subject: + whitespace-fixes-interval-timers.patch added to -mm tree
Date: Fri, 20 Jul 2007 17:19:04 -0700
Message-ID: <200707210019.l6L0J4Or023917@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43868 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755469AbXGUA2R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 20:28:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     whitespace fixes: interval timers
has been added to the -mm tree.  Its filename is
     whitespace-fixes-interval-timers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: whitespace fixes: interval timers
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/itimer.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/itimer.c~whitespace-fixes-interval-timers kernel/itimer.c
--- a/kernel/itimer.c~whitespace-fixes-interval-timers
+++ a/kernel/itimer.c
@@ -130,7 +130,7 @@ asmlinkage long sys_getitimer(int which,
 enum hrtimer_restart it_real_fn(struct hrtimer *timer)
 {
 	struct signal_struct *sig =
-	    container_of(timer, struct signal_struct, real_timer);
+		container_of(timer, struct signal_struct, real_timer);
 
 	send_group_sig_info(SIGALRM, SEND_SIG_PRIV, sig->tsk);
 
@@ -291,6 +291,6 @@ asmlinkage long sys_setitimer(int which,
 		return error;
 
 	if (copy_to_user(ovalue, &get_buffer, sizeof(get_buffer)))
-		return -EFAULT; 
+		return -EFAULT;
 	return 0;
 }
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
