From: akpm@linux-foundation.org
Subject: [folded-merged] sched-proc-sched_stat-fails-on-very-very-large-machines-fix.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:13:08 -0800
Message-ID: <20130221231309.268195A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:47695 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab3BUXNK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:13:10 -0500
Received: by mail-qe0-f74.google.com with SMTP id a11so9871qen.5
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:13:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davej@redhat.com, mingo@redhat.com, nzimmer@sgi.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sched-proc-sched_stat-fails-on-very-very-large-machines-fix
has been removed from the -mm tree.  Its filename was
     sched-proc-sched_stat-fails-on-very-very-large-machines-fix.patch

This patch was dropped because it was folded into sched-proc-sched_stat-fails-on-very-very-large-machines.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sched-proc-sched_stat-fails-on-very-very-large-machines-fix

fix memleak

Cc: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/stats.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched/stats.c~sched-proc-sched_stat-fails-on-very-very-large-machines-fix kernel/sched/stats.c
--- a/kernel/sched/stats.c~sched-proc-sched_stat-fails-on-very-very-large-machines-fix
+++ a/kernel/sched/stats.c
@@ -76,8 +76,8 @@ static int show_schedstat(struct seq_fil
 		}
 		rcu_read_unlock();
 #endif
-		kfree(mask_str);
 	}
+	kfree(mask_str);
 	return 0;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
goldfish-framebuffer-driver-fix.patch
ocfs2-remove-kfree-redundant-null-checks.patch
sched-proc-sched_stat-fails-on-very-very-large-machines.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-v2-fix.patch

