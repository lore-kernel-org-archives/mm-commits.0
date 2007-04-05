From: akpm@linux-foundation.org
Subject: - clocksource-parisc-initialize-list-value.patch removed from -mm tree
Date: Thu, 05 Apr 2007 12:28:44 -0700
Message-ID: <200704051928.l35JSisa024025@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49264 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbXDETg5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 5 Apr 2007 15:36:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, grundler@parisc-linux.org, johnstul@us.ibm.com, kyle@mcmartin.ca, mingo@elte.hu, tglx@linutronix.de, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     clocksource: parisc initialize list value
has been removed from the -mm tree.  Its filename was
     clocksource-parisc-initialize-list-value.patch

This patch was dropped because of general bunfight

------------------------------------------------------
Subject: clocksource: parisc initialize list value
From: Daniel Walker <dwalker@mvista.com>

Update arch/parisc/ with list initialization.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <willy@debian.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/time.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/parisc/kernel/time.c~clocksource-parisc-initialize-list-value arch/parisc/kernel/time.c
--- a/arch/parisc/kernel/time.c~clocksource-parisc-initialize-list-value
+++ a/arch/parisc/kernel/time.c
@@ -184,6 +184,7 @@ static struct clocksource clocksource_cr
 	.mult			= 0, /* to be set */
 	.shift			= 22,
 	.flags			= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list			= LIST_HEAD_INIT(clocksource_cr16.list),
 };
 
 #ifdef CONFIG_SMP
_

Patches currently in -mm which might be from dwalker@mvista.com are

clocksource-parisc-initialize-list-value.patch
clocksource-avr32-initialize-list-value.patch
clocksource-mips-initialize-list-value.patch
clocksource-i386-initialize-list-value.patch
clocksource-x86_64-initialize-list-value.patch
clocksource-s390-initialize-list-value.patch
clocksource-driver-initialize-list-value.patch
clocksource-refactor-duplicate-registration-checking.patch
slim-make-and-config-stuff.patch
profile-likely-unlikely-macros.patch
