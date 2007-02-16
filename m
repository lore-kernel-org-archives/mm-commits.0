From: akpm@linux-foundation.org
Subject: - time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch removed from -mm tree
Date: Fri, 16 Feb 2007 00:22:05 -0800
Message-ID: <200702160822.l1G8M5JK024403@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59721 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966198AbXBPIWY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 03:22:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@muc.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     time-x86_64-convert-x86_64-to-use-generic_time-tidy
has been removed from the -mm tree.  Its filename was
     time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch

This patch was dropped because it was folded into time-x86_64-convert-x86_64-to-use-generic_time.patch

------------------------------------------------------
Subject: time-x86_64-convert-x86_64-to-use-generic_time-tidy
From: Andrew Morton <akpm@osdl.org>

Cc: John Stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@muc.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/hpet.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6.20-rc6-mm/arch/x86_64/kernel/hpet.c
===================================================================
--- linux-2.6.20-rc6-mm.orig/arch/x86_64/kernel/hpet.c
+++ linux-2.6.20-rc6-mm/arch/x86_64/kernel/hpet.c
@@ -478,8 +478,7 @@ static int __init init_hpet_clocksource(
 		return -ENODEV;
 
 	/* calculate the hpet address: */
-	hpet_base =
-		(void __iomem*)ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
+	hpet_base = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
 	hpet_ptr = hpet_base + HPET_COUNTER;
 
 	/* calculate the frequency: */

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
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
