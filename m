From: akpm@linux-foundation.org
Subject: + include-linux-interrupth-do-not-include-linux-irqnrh-twice.patch added to -mm tree
Date: Mon, 05 Jan 2009 15:12:55 -0800
Message-ID: <200901052312.n05NCt35030585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750792AbZAEXND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 18:13:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jj@chaosbits.net


The patch titled
     include/linux/interrupt.h: do not include linux/irqnr.h twice
has been added to the -mm tree.  Its filename is
     include-linux-interrupth-do-not-include-linux-irqnrh-twice.patch

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

linux-next.patch
include-linux-interrupth-do-not-include-linux-irqnrh-twice.patch

