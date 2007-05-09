From: akpm@linux-foundation.org
Subject: - lockdep-lookup_chain_cache-comment-errata.patch removed from -mm tree
Date: Tue, 08 May 2007 19:50:22 -0700
Message-ID: <200705090250.l492oMZd009345@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969982AbXEICuc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:50:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarkao2@o2.pl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockdep: lookup_chain_cache comment errata
has been removed from the -mm tree.  Its filename was
     lockdep-lookup_chain_cache-comment-errata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: lookup_chain_cache comment errata
From: Jarek Poplawski <jarkao2@o2.pl>

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/lockdep.c~lockdep-lookup_chain_cache-comment-errata kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-lookup_chain_cache-comment-errata
+++ a/kernel/lockdep.c
@@ -1309,8 +1309,9 @@ out_unlock_set:
 
 /*
  * Look up a dependency chain. If the key is not present yet then
- * add it and return 0 - in this case the new dependency chain is
- * validated. If the key is already hashed, return 1.
+ * add it and return 1 - in this case the new dependency chain is
+ * validated. If the key is already hashed, return 0.
+ * (On return with 1 graph_lock is held.)
  */
 static inline int lookup_chain_cache(u64 chain_key, struct lock_class *class)
 {
_

Patches currently in -mm which might be from jarkao2@o2.pl are

origin.patch
ppp_generic-fix-lockdep-warning.patch
make-cancel_rearming_delayed_work-reliable.patch
make-cancel_rearming_delayed_work-reliable-spelling.patch
timer-parenthesis-fix-in-tbase_get_deferrable-etc.patch
