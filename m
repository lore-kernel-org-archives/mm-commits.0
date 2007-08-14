From: akpm@linux-foundation.org
Subject: - rcu-remove-prototype-for-nonexistent-function.patch removed from -mm tree
Date: Mon, 13 Aug 2007 22:03:35 -0700
Message-ID: <200708140503.l7E53ZYo032070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45587 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934354AbXHNFLO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 01:11:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josht@linux.vnet.ibm.com, josh@kernel.org, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     RCU: Remove prototype for nonexistent function synchronize_idle()
has been removed from the -mm tree.  Its filename was
     rcu-remove-prototype-for-nonexistent-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: RCU: Remove prototype for nonexistent function synchronize_idle()
From: Josh Triplett <josht@linux.vnet.ibm.com>

synchronize_idle() sounds like an interesting function, but we don't
actually have it, so don't prototype it.  Introduced in commit
9b06e818985d139fd9e82c28297f7744e1b484e1, in 2005.

Signed-off-by: Josh Triplett <josh@kernel.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rcupdate.h |    1 -
 1 files changed, 1 deletion(-)

diff -puN include/linux/rcupdate.h~rcu-remove-prototype-for-nonexistent-function include/linux/rcupdate.h
--- a/include/linux/rcupdate.h~rcu-remove-prototype-for-nonexistent-function
+++ a/include/linux/rcupdate.h
@@ -281,7 +281,6 @@ extern void FASTCALL(call_rcu(struct rcu
 extern void FASTCALL(call_rcu_bh(struct rcu_head *head,
 				void (*func)(struct rcu_head *head)));
 extern void synchronize_rcu(void);
-void synchronize_idle(void);
 extern void rcu_barrier(void);
 
 #endif /* __KERNEL__ */
_

Patches currently in -mm which might be from josht@linux.vnet.ibm.com are

i386-mark-pit_clockevent-static.patch
