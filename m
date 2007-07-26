From: akpm@linux-foundation.org
Subject: + x86_64-cleanup-tscc-merge-artifact.patch added to -mm tree
Date: Thu, 26 Jul 2007 03:15:28 -0700
Message-ID: <200707261015.l6QAFSjU026454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35871 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754910AbXGZKQJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 06:16:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de


The patch titled
     x86_64: cleanup tsc.c merge artifact
has been added to the -mm tree.  Its filename is
     x86_64-cleanup-tscc-merge-artifact.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
x86_64-cleanup-tscc-merge-artifact.patch
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
drivers-char-hpetc-integer-constant-is-too-large-for-long-type.patch
time-simplify-smp_call_function_single-call-sequence.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
