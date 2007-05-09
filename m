From: akpm@linux-foundation.org
Subject: - export-hrtimer_forward.patch removed from -mm tree
Date: Tue, 08 May 2007 19:52:42 -0700
Message-ID: <200705090252.l492qgP2009602@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755036AbXEICxS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:53:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stsp@aknet.ru, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     export hrtimer_forward
has been removed from the -mm tree.  Its filename was
     export-hrtimer_forward.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: export hrtimer_forward
From: Stas Sergeev <stsp@aknet.ru>

Other symbols of the hrtimers API are already exported.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hrtimer.c |    1 +
 1 file changed, 1 insertion(+)

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

origin.patch
