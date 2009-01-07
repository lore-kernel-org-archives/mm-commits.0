From: akpm@linux-foundation.org
Subject: - include-linux-interrupth-do-not-include-linux-irqnrh-twice.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:16:24 -0800
Message-ID: <200901072216.n07MGOvb016098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760003AbZAGWQa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:16:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jj@chaosbits.net, mm-commits@vger.kernel.org


The patch titled
     include/linux/interrupt.h: do not include linux/irqnr.h twice
has been removed from the -mm tree.  Its filename was
     include-linux-interrupth-do-not-include-linux-irqnrh-twice.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/interrupt.h: do not include linux/irqnr.h twice
From: Jesper Juhl <jj@chaosbits.net>

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/interrupt.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/interrupt.h~include-linux-interrupth-do-not-include-linux-irqnrh-twice include/linux/interrupt.h
--- a/include/linux/interrupt.h~include-linux-interrupth-do-not-include-linux-irqnrh-twice
+++ a/include/linux/interrupt.h
@@ -14,7 +14,6 @@
 #include <linux/irqflags.h>
 #include <linux/smp.h>
 #include <linux/percpu.h>
-#include <linux/irqnr.h>
 
 #include <asm/atomic.h>
 #include <asm/ptrace.h>
_

Patches currently in -mm which might be from jj@chaosbits.net are

origin.patch
linux-next.patch

