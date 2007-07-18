From: akpm@linux-foundation.org
Subject: + add-posix-clocks-and-timers-maintainer.patch added to -mm tree
Date: Wed, 18 Jul 2007 15:47:46 -0700
Message-ID: <200707182247.l6IMlk4m000512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39408 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757074AbXGRWsb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 18:48:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de


The patch titled
     add POSIX clocks and timers maintainer
has been added to the -mm tree.  Its filename is
     add-posix-clocks-and-timers-maintainer.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~add-posix-clocks-and-timers-maintainer MAINTAINERS
--- a/MAINTAINERS~add-posix-clocks-and-timers-maintainer
+++ a/MAINTAINERS
@@ -2849,8 +2849,8 @@ L:	linux-kernel@vger.kernel.org
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
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
time-make-sure-sys_gettimeofday-and-sys_time-are-in.patch
fix-the-softlockup-watchdog-to-actually-work.patch
add-posix-clocks-and-timers-maintainer.patch
fix-raw_spinlock_t-vs-lockdep.patch
lockdep-sanitise-config_prove_locking.patch
lockdep-reduce-the-ifdeffery.patch
lockstat-core-infrastructure.patch
lockstat-human-readability-tweaks.patch
lockstat-human-readability-tweaks-fix.patch
lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch
lockdep-various-fixes.patch
lockdep-fixup-sk_callback_lock-annotation.patch
lockstat-measure-lock-bouncing.patch
lockstat-better-class-name-representation.patch
lockdep-debugging-give-stacktrace-for-init_error.patch
stacktrace-fix-header-file-for-config_stacktrace.patch
git-acpi.patch
git-kvm.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
tick-management-spread-timer-interrupt.patch
highres-improve-debug-output.patch
hrtimer-speedup-hrtimer_enqueue.patch
pcspkr-use-the-global-pit-lock.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
i386-remove-volatile-in-apicc.patch
i386-hpet-assumes-boot-cpu-is-0.patch
i386-move-pit-function-declarations-and-constants-to-correct-header-file.patch
x86_64-untangle-asm-hpeth-from-asm-timexh.patch
x86_64-use-generic-cmos-update.patch
x86_64-remove-dead-code-and-other-janitor-work-in-tscc.patch
x86_64-fix-apic-typo.patch
x86_64-convert-to-cleckevents.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
geode-mfgpt-clock-event-device-support.patch
i386-ioapic-remove-old-irq-balancing-debug-cruft.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
sys_time-use-barrier-instead-of-smp_rmb.patch
immunize-rcu_dereference-against-crazy-compiler-writers.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
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
