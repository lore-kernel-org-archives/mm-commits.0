From: akpm@linux-foundation.org
Subject: - clocksource-s390-initialize-list-value.patch removed from -mm tree
Date: Thu, 05 Apr 2007 12:29:03 -0700
Message-ID: <200704051929.l35JT3wW024049@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49056 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767232AbXDETbM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 5 Apr 2007 15:31:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, heiko.carstens@de.ibm.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clocksource: s390 initialize list value
has been removed from the -mm tree.  Its filename was
     clocksource-s390-initialize-list-value.patch

This patch was dropped because of general bunfight

------------------------------------------------------
Subject: clocksource: s390 initialize list value
From: Daniel Walker <dwalker@mvista.com>

Update arch/s390 with list initialization.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/time.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/s390/kernel/time.c~clocksource-s390-initialize-list-value arch/s390/kernel/time.c
--- a/arch/s390/kernel/time.c~clocksource-s390-initialize-list-value
+++ a/arch/s390/kernel/time.c
@@ -314,6 +314,7 @@ static struct clocksource clocksource_to
 	.mult		= 1000,
 	.shift		= 12,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list		= LIST_HEAD_INIT(clocksource_tod.list),
 };
 
 
_

Patches currently in -mm which might be from dwalker@mvista.com are

clocksource-s390-initialize-list-value.patch
clocksource-driver-initialize-list-value.patch
clocksource-refactor-duplicate-registration-checking.patch
slim-make-and-config-stuff.patch
profile-likely-unlikely-macros.patch
