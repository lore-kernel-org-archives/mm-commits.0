From: akpm@linux-foundation.org
Subject: + cfs-fix-missing-digit-off-in-wmult-table.patch added to -mm tree
Date: Fri, 13 Jul 2007 13:33:45 -0700
Message-ID: <200707132033.l6DKXjgn018119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39045 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760675AbXGMUeb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 16:34:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu


The patch titled
     CFS: fix missing digit off in wmult table
has been added to the -mm tree.  Its filename is
     cfs-fix-missing-digit-off-in-wmult-table.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CFS: fix missing digit off in wmult table
From: Thomas Gleixner <tglx@linutronix.de>

Roman Zippel noticed inconsistency of the wmult table.

wmult[16] has a missing digit.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~cfs-fix-missing-digit-off-in-wmult-table kernel/sched.c
--- a/kernel/sched.c~cfs-fix-missing-digit-off-in-wmult-table
+++ a/kernel/sched.c
@@ -750,7 +750,7 @@ static const u32 prio_to_wmult[40] = {
 	48356,   60446,   75558,   94446,  118058,  147573,
 	184467,  230589,  288233,  360285,  450347,
 	562979,  703746,  879575, 1099582, 1374389,
-	717986, 2147483, 2684354, 3355443, 4194304,
+	1717986, 2147483, 2684354, 3355443, 4194304,
 	244160, 6557201, 8196502, 10250518, 12782640,
 	16025997, 19976592, 24970740, 31350126, 39045157,
 	49367440, 61356675, 76695844, 95443717, 119304647,
_

Patches currently in -mm which might be from tglx@linutronix.de are

cfs-fix-missing-digit-off-in-wmult-table.patch
git-acpi.patch
git-arm.patch
i386-hpet-check-if-the-counter-works.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
timekeeping-fixup-shadow-variable-argument.patch
timerc-cleanup-recently-introduced-whitespace-damage.patch
clockevents-remove-prototypes-of-removed-functions.patch
clockevents-fix-resume-logic.patch
clockevents-fix-device-replacement.patch
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
i386-x86_64-insert-hpet-firmware-resource-after-pci-enumeration-has-completed.patch
introduce-boot-based-time.patch
use-boot-based-time-for-process-start-time-and-boot-time.patch
remove-clockevents_releaserequest_device.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
improve-behaviour-of-spurious-irq-detect.patch
sys_time-speedup.patch
futex-tidy-up-the-code-v2.patch
make-timespec_equal-take-const-arguments.patch
lguest-the-host-code.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
