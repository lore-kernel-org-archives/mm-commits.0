From: akpm@osdl.org
Subject: - updated-dyntick-add-nohz-stats-to-proc-stat.patch removed from -mm tree
Date: Wed, 13 Dec 2006 14:49:56 -0800
Message-ID: <200612132249.kBDMnuSb023186@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53104 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbWLMWuN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:50:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     dyntick: add nohz stats to /proc/stat
has been removed from the -mm tree.  Its filename was
     updated-dyntick-add-nohz-stats-to-proc-stat.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: dyntick: add nohz stats to /proc/stat
From: Thomas Gleixner <tglx@linutronix.de>

Add nohz stats to /proc/stat.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/proc/proc_misc.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/proc/proc_misc.c~updated-dyntick-add-nohz-stats-to-proc-stat fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~updated-dyntick-add-nohz-stats-to-proc-stat
+++ a/fs/proc/proc_misc.c
@@ -528,6 +528,8 @@ static int show_stat(struct seq_file *p,
 		nr_running(),
 		nr_iowait());
 
+	show_no_hz_stats(p);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-mtd.patch
gtod-uninline-jiffiesh.patch
gtod-fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
gtod-fix-timeout-overflow.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-uninline-irq_enter.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-include-fix.patch
acpi-keep-track-of-timer-broadcast.patch
acpi-add-state-propagation-for-dynamic-broadcasting.patch
acpi-cleanups-allow-early-access-to-pmtimer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-core.patch
clockevents-i386-drivers.patch
clockevents-i386-hpet-driver.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
high-res-timers-core.patch
high-res-timers-core-do-itimer-rearming-in-process-context.patch
high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
dynticks-i386-prepare-nmi-watchdog.patch
high-res-timers-dynticks-i386-support-enable-in-kconfig.patch
debugging-feature-add-proc-timer_stat.patch

