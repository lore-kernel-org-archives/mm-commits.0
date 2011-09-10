From: akpm@linux-foundation.org
Subject: + lib-idrc-fix-comment-for-ida_get_new_above.patch added to -mm tree
Date: Fri, 09 Sep 2011 17:02:11 -0700
Message-ID: <201109100002.p8A02BFx014217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751743Ab1IJACM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2011 20:02:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shhuiw@gmail.com


The patch titled
     lib/idr.c: fix comment for ida_get_new_above()
has been added to the -mm tree.  Its filename is
     lib-idrc-fix-comment-for-ida_get_new_above.patch

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
Subject: lib/idr.c: fix comment for ida_get_new_above()
From: Wang Sheng-Hui <shhuiw@gmail.com>

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

linux-next.patch
lib-idrc-fix-comment-for-ida_get_new_above.patch

