From: akpm@linux-foundation.org
Subject: [folded-merged] sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:13:14 -0800
Message-ID: <20130221231314.DE04631C016@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:37584 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab3BUXNQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:13:16 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so10179vch.0
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:13:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davej@redhat.com, mingo@redhat.com, nzimmer@sgi.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix
has been removed from the -mm tree.  Its filename was
     sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix.patch

This patch was dropped because it was folded into sched-proc-sched_stat-fails-on-very-very-large-machines.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix

fix spello in comment

Cc: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/stats.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched/stats.c~sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix kernel/sched/stats.c
--- a/kernel/sched/stats.c~sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix
+++ a/kernel/sched/stats.c
@@ -82,7 +82,7 @@ static int show_schedstat(struct seq_fil
 }
 
 /*
- * This itererator needs some explination.
+ * This itererator needs some explanation.
  * It returns 1 for the header position.
  * This means 2 is cpu 0.
  * In a hotplugged system some cpus, including cpu 0, may be missing so we have
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
goldfish-framebuffer-driver-fix.patch
ocfs2-remove-kfree-redundant-null-checks.patch
sched-proc-sched_stat-fails-on-very-very-large-machines.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-v2-fix.patch

