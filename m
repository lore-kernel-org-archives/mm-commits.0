From: akpm@linux-foundation.org
Subject: - hrtimers-hrtimer_clock_base-description-typo.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:21:14 -0800
Message-ID: <200703070421.l274LEMt018883@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47008 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161293AbXCGEVV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:21:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@debian.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     hrtimers: hrtimer_clock_base description typo
has been removed from the -mm tree.  Its filename was
     hrtimers-hrtimer_clock_base-description-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hrtimers: hrtimer_clock_base description typo
From: Andres Salomon <dilinger@debian.org>

The description for the hrtimer_clock_base struct describes "hrtimer_base".
 That should be hrtimer_clock_base.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hrtimer.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/hrtimer.h~hrtimers-hrtimer_clock_base-description-typo include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~hrtimers-hrtimer_clock_base-description-typo
+++ a/include/linux/hrtimer.h
@@ -139,7 +139,7 @@ struct hrtimer_sleeper {
 };
 
 /**
- * struct hrtimer_base - the timer base for a specific clock
+ * struct hrtimer_clock_base - the timer base for a specific clock
  * @cpu_base:		per cpu clock base
  * @index:		clock type index for per_cpu support when moving a
  *			timer to a base on another cpu.
_

Patches currently in -mm which might be from dilinger@debian.org are

origin.patch
