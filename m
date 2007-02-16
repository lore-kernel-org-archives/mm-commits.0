From: akpm@linux-foundation.org
Subject: - time-x86_64-split-x86_64-kernel-timec-up-fix.patch removed from -mm tree
Date: Fri, 16 Feb 2007 00:20:30 -0800
Message-ID: <200702160820.l1G8KVTJ024371@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60180 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966219AbXBPI1y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 03:27:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@muc.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     time-x86_64-split-x86_64-kernel-timec-up-fix
has been removed from the -mm tree.  Its filename was
     time-x86_64-split-x86_64-kernel-timec-up-fix.patch

This patch was dropped because it was folded into time-x86_64-split-x86_64-kernel-timec-up.patch

------------------------------------------------------
Subject: time-x86_64-split-x86_64-kernel-timec-up-fix
From: Andrew Morton <akpm@osdl.org>

kernel/tsacct.c:26:1: warning: "USEC_PER_TICK" redefined
In file included from include/linux/timex.h:187,
                 from include/linux/sched.h:50,
                 from kernel/tsacct.c:20:
include/asm/timex.h:47:1: warning: this is the location of the previous definition

Cc: John Stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@muc.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/tsacct.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6.20-rc6-mm/kernel/tsacct.c
===================================================================
--- linux-2.6.20-rc6-mm.orig/kernel/tsacct.c
+++ linux-2.6.20-rc6-mm/kernel/tsacct.c
@@ -22,8 +22,6 @@
 #include <linux/acct.h>
 #include <linux/jiffies.h>
 
-
-#define USEC_PER_TICK	(USEC_PER_SEC/HZ)
 /*
  * fill in basic accounting fields
  */

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
vmi-versus-hrtimers.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
i386-use-gtod-persistent-clock-support.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i383-drivers.patch
generic-vsyscall-gtod-support-for-generic_time.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
