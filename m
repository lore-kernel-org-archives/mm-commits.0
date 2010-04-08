From: akpm@linux-foundation.org
Subject: + x86-remove-last-traces-of-quicklist-usage.patch added to -mm tree
Date: Thu, 08 Apr 2010 14:22:36 -0700
Message-ID: <201004082122.o38LMaaL009678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759030Ab0DHVW6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Apr 2010 17:22:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: remove last traces of quicklist usage
has been added to the -mm tree.  Its filename is
     x86-remove-last-traces-of-quicklist-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: remove last traces of quicklist usage
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

We still have a stray quicklist header included even though we axed
quicklist usage quite a while back.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pgtable_32.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/x86/mm/pgtable_32.c~x86-remove-last-traces-of-quicklist-usage arch/x86/mm/pgtable_32.c
--- a/arch/x86/mm/pgtable_32.c~x86-remove-last-traces-of-quicklist-usage
+++ a/arch/x86/mm/pgtable_32.c
@@ -9,7 +9,6 @@
 #include <linux/pagemap.h>
 #include <linux/spinlock.h>
 #include <linux/module.h>
-#include <linux/quicklist.h>
 
 #include <asm/system.h>
 #include <asm/pgtable.h>
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
x86-remove-last-traces-of-quicklist-usage.patch
powerpc-add-rcu_read_lock-to-gup_fast-implementation.patch
cpu-timers-simplify-rlimit_cpu-handling.patch
cpu-timers-cleanup-arm_timer.patch
cpu-timers-return-correct-previous-timer-reload-value.patch
cpu-timers-change-sigev_none-timer-implementation.patch
cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
cpu-timers-optimize-run_posix_cpu_timers.patch
rcu-remove-init_rcu_head-rcu_head_init-rcu_head.patch
mm-revalidate-anon_vma-in-page_lock_anon_vma.patch
kernel-user-remove-unreachable-code.patch
bitops-optimize-hweight-by-making-use-of-compile-time-evaluation.patch
x86-add-optimized-popcnt-variants.patch

