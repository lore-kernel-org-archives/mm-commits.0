From: akpm@linux-foundation.org
Subject: - whitespace-fixes-interval-timers.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:43:59 -0700
Message-ID: <200710190343.l9J3hxpf013110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43711 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966101AbXJSD4f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     whitespace fixes: interval timers
has been removed from the -mm tree.  Its filename was
     whitespace-fixes-interval-timers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: whitespace fixes: interval timers
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/itimer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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

origin.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
