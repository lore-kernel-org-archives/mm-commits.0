From: akpm@linux-foundation.org
Subject: - x86-tracehook-config_have_arch_tracehook.patch removed from -mm tree
Date: Tue, 23 Sep 2008 04:33:13 -0700
Message-ID: <200809231133.m8NBXD2l029917@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751184AbYIWLeM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Sep 2008 07:34:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: tracehook: CONFIG_HAVE_ARCH_TRACEHOOK
has been removed from the -mm tree.  Its filename was
     x86-tracehook-config_have_arch_tracehook.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: tracehook: CONFIG_HAVE_ARCH_TRACEHOOK
From: Roland McGrath <roland@redhat.com>

The x86 arch code has all the prerequisites, so set HAVE_ARCH_TRACEHOOK.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/Kconfig~x86-tracehook-config_have_arch_tracehook arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-tracehook-config_have_arch_tracehook
+++ a/arch/x86/Kconfig
@@ -22,6 +22,7 @@ config X86
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_ARCH_TRACEHOOK
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
 	select ARCH_WANT_OPTIONAL_GPIOLIB
_

Patches currently in -mm which might be from roland@redhat.com are

kernel-doc-allow-structs-whose-members-are-all-private.patch
sys_paccept-disable-paccept-until-api-design-is-resolved.patch
linux-next.patch
x86-tracehook-config_have_arch_tracehook.patch
posix-timers-dont-switch-to-group_leader-if-it_process-dies.patch
posix-timers-always-do-get_task_structtimer-it_process.patch
posix-timers-sys_timer_create-remove-the-buggy-pf_exiting-check.patch
posix-timers-sys_timer_create-simplify-and-s-tasklist-rcu.patch
posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path.patch
posix-timers-sys_timer_create-cleanup-the-error-handling.patch
posix-timers-kill-it_sigev_signo-and-it_sigev_value.patch
posix-timers-lock_timer-kill-the-bogus-it_id-check.patch
posix-timers-lock_timer-make-it-readable.patch
posix-timers-use-struct-pid-instead-of-struct-task_struct.patch
posix-timers-check-it_signal-instead-of-it_pid-to-validate-the-timer.patch
posix-timers-simplify-de_thread-exit_itimers-path.patch
make-ptrace_untrace-static.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

