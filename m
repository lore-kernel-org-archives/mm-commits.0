From: akpm@linux-foundation.org
Subject: + export-hrtimer_forward.patch added to -mm tree
Date: Thu, 03 May 2007 17:40:04 -0700
Message-ID: <200705040040.l440e5So025976@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767546AbXEDAku (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 20:40:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stsp@aknet.ru, mingo@elte.hu, tglx@linutronix.de


The patch titled
     export hrtimer_forward
has been added to the -mm tree.  Its filename is
     export-hrtimer_forward.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: export hrtimer_forward
From: Stas Sergeev <stsp@aknet.ru>

Other symbols of the hrtimers API are already exported.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hrtimer.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN kernel/hrtimer.c~export-hrtimer_forward kernel/hrtimer.c
--- a/kernel/hrtimer.c~export-hrtimer_forward
+++ a/kernel/hrtimer.c
@@ -669,6 +669,7 @@ hrtimer_forward(struct hrtimer *timer, k
 
 	return orun;
 }
+EXPORT_SYMBOL_GPL(hrtimer_forward);
 
 /*
  * enqueue_hrtimer - internal function to (re)start a timer
_

Patches currently in -mm which might be from stsp@aknet.ru are

export-hrtimer_forward.patch
