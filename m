From: akpm@linux-foundation.org
Subject: - add-posix-clocks-and-timers-maintainer.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:02:30 -0700
Message-ID: <200707192002.l6JK2Us3019675@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41723 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755357AbXGSUSI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:18:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     add POSIX clocks and timers maintainer
has been removed from the -mm tree.  Its filename was
     add-posix-clocks-and-timers-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: add POSIX clocks and timers maintainer
From: Ingo Molnar <mingo@elte.hu>

Update the MAINTAINERS file: Thomas Gleixner has been the de-facto
maintainer of POSIX timers and clocks for quite some time.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~add-posix-clocks-and-timers-maintainer MAINTAINERS
--- a/MAINTAINERS~add-posix-clocks-and-timers-maintainer
+++ a/MAINTAINERS
@@ -2857,8 +2857,8 @@ L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
 POSIX CLOCKS and TIMERS
-P:	George Anzinger
-M:	george@mvista.com
+P:	Thomas Gleixner
+M:	tglx@linutronix.de
 L:	linux-kernel@vger.kernel.org
 S:	Supported
 
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
git-acpi.patch
git-kvm.patch
git-sched.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
tick-management-spread-timer-interrupt.patch
highres-improve-debug-output.patch
hrtimer-speedup-hrtimer_enqueue.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
geode-mfgpt-clock-event-device-support.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
sys_time-use-barrier-instead-of-smp_rmb.patch
immunize-rcu_dereference-against-crazy-compiler-writers.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
fix-the-softlockup-watchdog-to-actually-work.patch
softlockup-make-asm-irq_regsh-available-on-every-platform.patch
softlockup-improve-debug-output.patch
softlockup-watchdog-style-cleanups.patch
futex-pass-nr_wake2-to-futex_wake_op.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
random-warning-squishes.patch
