From: akpm@linux-foundation.org
Subject: + hrtimers-hrtimer_clock_base-description-typo.patch added to -mm tree
Date: Mon, 05 Mar 2007 19:19:21 -0800
Message-ID: <200703060319.l263JLQh010463@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48680 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933896AbXCFDTb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 22:19:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@debian.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     hrtimers: hrtimer_clock_base description typo
has been added to the -mm tree.  Its filename is
     hrtimers-hrtimer_clock_base-description-typo.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

i386-make-x86_64-tsc-header-require-i386-rather-than-vice-versa.patch
hrtimers-fix-hrtimer_cb_irqsafe_no_softirq-description.patch
hrtimers-hrtimer_clock_base-description-typo.patch
