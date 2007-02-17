From: akpm@linux-foundation.org
Subject: - clocksource-fixup-is_continous-changes-on-s390.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:14:00 -0800
Message-ID: <200702170714.l1H7E0ns021497@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51255 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946557AbXBQHRl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:17:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu, schwidefsky@de.ibm.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     clocksource: fixup is_continous changes on S390
has been removed from the -mm tree.  Its filename was
     clocksource-fixup-is_continous-changes-on-s390.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: clocksource: fixup is_continous changes on S390
From: Thomas Gleixner <tglx@linutronix.de>

Fixup the is_contionous replacement by a flag field.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/s390/kernel/time.c~clocksource-fixup-is_continous-changes-on-s390 arch/s390/kernel/time.c
--- a/arch/s390/kernel/time.c~clocksource-fixup-is_continous-changes-on-s390
+++ a/arch/s390/kernel/time.c
@@ -312,7 +312,7 @@ static struct clocksource clocksource_to
 	.mask		= -1ULL,
 	.mult		= 1000,
 	.shift		= 12,
-	.is_continuous	= 1,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
git-block.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
