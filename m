From: akpm@linux-foundation.org
Subject: [merged] lib-idrc-fix-comment-for-ida_get_new_above.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:16:06 -0700
Message-ID: <201111012116.pA1LG63W018681@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16686 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab1KAVQK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:16:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shhuiw@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/idr.c: fix comment for ida_get_new_above()
has been removed from the -mm tree.  Its filename was
     lib-idrc-fix-comment-for-ida_get_new_above.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: lib/idr.c: fix comment for ida_get_new_above()

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/idr.c~lib-idrc-fix-comment-for-ida_get_new_above lib/idr.c
--- a/lib/idr.c~lib-idrc-fix-comment-for-ida_get_new_above
+++ a/lib/idr.c
@@ -767,8 +767,8 @@ EXPORT_SYMBOL(ida_pre_get);
  * @starting_id: id to start search at
  * @p_id:	pointer to the allocated handle
  *
- * Allocate new ID above or equal to @ida.  It should be called with
- * any required locks.
+ * Allocate new ID above or equal to @starting_id.  It should be called
+ * with any required locks.
  *
  * If memory is required, it will return %-EAGAIN, you should unlock
  * and go back to the ida_pre_get() call.  If the ida is full, it will
_

Patches currently in -mm which might be from shhuiw@gmail.com are

origin.patch
linux-next.patch

