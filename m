From: akpm@linux-foundation.org
Subject: - git-sched-schedc-needs-tickh.patch removed from -mm tree
Date: Tue, 08 Apr 2008 11:59:22 -0700
Message-ID: <200804081859.m38IxMWj006979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755493AbYDHS7p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2008 14:59:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tremyfr@yahoo.fr, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     git-sched: sched.c needs tick.h
has been removed from the -mm tree.  Its filename was
     git-sched-schedc-needs-tickh.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: git-sched: sched.c needs tick.h
=46rom: Reynes Philippe <tremyfr@yahoo.fr>

kernel/sched.c: In function =91nohz_on=92:
kernel/sched.c:506: erreur: implicit declaration of function =91tick_ge=
t_tick_sched=92
kernel/sched.c:506: erreur: invalid type argument of =91->=92
kernel/sched.c:506: erreur: =91NOHZ_MODE_INACTIVE=92 undeclared (first =
use in this function)
kernel/sched.c:506: erreur: (Each undeclared identifier is reported onl=
y once
kernel/sched.c:506: erreur: for each function it appears in.)

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/sched.c~git-sched-schedc-needs-tickh kernel/sched.c
--- a/kernel/sched.c~git-sched-schedc-needs-tickh
+++ a/kernel/sched.c
@@ -66,6 +66,7 @@
 #include <linux/unistd.h>
 #include <linux/pagemap.h>
 #include <linux/hrtimer.h>
+#include <linux/tick.h>
=20
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
_

Patches currently in -mm which might be from tremyfr@yahoo.fr are

git-sched.patch
add-warn_on_secs-macro-simplification-fix-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
