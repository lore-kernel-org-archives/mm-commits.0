From: akpm@osdl.org
Subject: - schedc-correct-comment-for-this_rq_lock-routine.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:53:13 -0800
Message-ID: <200612130653.kBD6rDAU030498@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57491 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964994AbWLMGxU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:53:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     sched.c: correct comment for this_rq_lock()
has been removed from the -mm tree.  Its filename was
     schedc-correct-comment-for-this_rq_lock-routine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched.c: correct comment for this_rq_lock()
From: Robert P. J. Day <rpjday@mindspring.com>

Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~schedc-correct-comment-for-this_rq_lock-routine kernel/sched.c
--- a/kernel/sched.c~schedc-correct-comment-for-this_rq_lock-routine
+++ a/kernel/sched.c
@@ -547,7 +547,7 @@ rq_sched_info_depart(struct rq *rq, unsi
 #endif
 
 /*
- * rq_lock - lock a given runqueue and disable interrupts.
+ * this_rq_lock - lock this runqueue and disable interrupts.
  */
 static inline struct rq *this_rq_lock(void)
 	__acquires(rq->lock)
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
kbuild-make-fusion-mpt-selectable-from-device-drivers.patch
fix-numerous-kcalloc-calls-convert-to-kzalloc.patch
getting-rid-of-all-casts-of-kalloc-calls.patch

