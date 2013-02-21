From: akpm@linux-foundation.org
Subject: [folded-merged] sched-proc-sched_debug-fails-on-very-very-large-machines-fix.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:14:09 -0800
Message-ID: <20130221231409.8E8535A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:49111 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab3BUXOK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:14:10 -0500
Received: by mail-qc0-f202.google.com with SMTP id k26so9967qcs.5
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:14:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davej@redhat.com, mingo@redhat.com, nzimmer@sgi.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sched-proc-sched_debug-fails-on-very-very-large-machines-fix
has been removed from the -mm tree.  Its filename was
     sched-proc-sched_debug-fails-on-very-very-large-machines-fix.patch

This patch was dropped because it was folded into sched-proc-sched_debug-fails-on-very-very-large-machines.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sched-proc-sched_debug-fails-on-very-very-large-machines-fix

whitespace fixlet

Cc: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>)
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/debug.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/sched/debug.c~sched-proc-sched_debug-fails-on-very-very-large-machines-fix kernel/sched/debug.c
--- a/kernel/sched/debug.c~sched-proc-sched_debug-fails-on-very-very-large-machines-fix
+++ a/kernel/sched/debug.c
@@ -437,7 +437,6 @@ static void sched_debug_stop(struct seq_
 {
 }
 
