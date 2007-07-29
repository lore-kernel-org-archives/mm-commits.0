From: akpm@linux-foundation.org
Subject: - x86_64-cleanup-tscc-merge-artifact.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:12:35 -0700
Message-ID: <200707290612.l6T6CZEF011136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41929 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759393AbXG2GYL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:24:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: cleanup tsc.c merge artifact
has been removed from the -mm tree.  Its filename was
     x86_64-cleanup-tscc-merge-artifact.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: cleanup tsc.c merge artifact
From: Thomas Gleixner <tglx@linutronix.de>

tsc_unstable is declared twice.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/tsc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN arch/x86_64/kernel/tsc.c~x86_64-cleanup-tscc-merge-artifact arch/x86_64/kernel/tsc.c
--- a/arch/x86_64/kernel/tsc.c~x86_64-cleanup-tscc-merge-artifact
+++ a/arch/x86_64/kernel/tsc.c
@@ -118,8 +118,6 @@ core_initcall(cpufreq_tsc);
 
 #endif
 
-static int tsc_unstable = 0;
-
 /*
  * Make an educated guess if the TSC is trustworthy and synchronized
  * over all CPUs.
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
geode-mfgpt-clock-event-device-support.patch
time-simplify-smp_call_function_single-call-sequence.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
