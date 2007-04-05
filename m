From: akpm@linux-foundation.org
Subject: - clocksource-mips-initialize-list-value.patch removed from -mm tree
Date: Thu, 05 Apr 2007 12:28:51 -0700
Message-ID: <200704051928.l35JSpY8024040@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49112 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767253AbXDETdB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 5 Apr 2007 15:33:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, johnstul@us.ibm.com, mingo@elte.hu, ralf@linux-mips.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clocksource: mips initialize list value
has been removed from the -mm tree.  Its filename was
     clocksource-mips-initialize-list-value.patch

This patch was dropped because of general bunfight

------------------------------------------------------
Subject: clocksource: mips initialize list value
From: Daniel Walker <dwalker@mvista.com>

Update arch/mips/ with list initialization.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/time.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/mips/kernel/time.c~clocksource-mips-initialize-list-value arch/mips/kernel/time.c
--- a/arch/mips/kernel/time.c~clocksource-mips-initialize-list-value
+++ a/arch/mips/kernel/time.c
@@ -308,6 +308,7 @@ struct clocksource clocksource_mips = {
 	.name		= "MIPS",
 	.mask		= 0xffffffff,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list		= LIST_HEAD_INIT(clocksource_mips.list),
 };
 
 static void __init init_mips_clocksource(void)
_

Patches currently in -mm which might be from dwalker@mvista.com are

clocksource-mips-initialize-list-value.patch
clocksource-i386-initialize-list-value.patch
clocksource-x86_64-initialize-list-value.patch
clocksource-s390-initialize-list-value.patch
clocksource-driver-initialize-list-value.patch
clocksource-refactor-duplicate-registration-checking.patch
slim-make-and-config-stuff.patch
profile-likely-unlikely-macros.patch
