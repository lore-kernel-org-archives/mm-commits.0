From: akpm@linux-foundation.org
Subject: + lib-interval-tree-correct-comment-wrt-generic-flavor.patch
 added to -mm tree
Date: Wed, 19 Jul 2017 15:53:17 -0700
Message-ID: <596fe2dd.ANJcUZlHzQSHHHWX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38482 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932861AbdGSWxS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2017 18:53:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, jack@suse.cz, kirill.shutemov@linux.intel.com, ldufour@linux.vnet.ibm.com, mgorman@techsingularity.net, mhocko@suse.com, mingo@kernel.org, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/interval-tree: correct comment wrt generic flavor
has been added to the -mm tree.  Its filename is
     lib-interval-tree-correct-comment-wrt-generic-flavor.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-interval-tree-correct-comment-wrt-generic-flavor.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-interval-tree-correct-comment-wrt-generic-flavor.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: lib/interval-tree: correct comment wrt generic flavor

interval_tree.h _is_ the generic flavor.

Link: http://lkml.kernel.org/r/20170629171553.2146-8-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/interval_tree_generic.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/interval_tree_generic.h~lib-interval-tree-correct-comment-wrt-generic-flavor include/linux/interval_tree_generic.h
--- a/include/linux/interval_tree_generic.h~lib-interval-tree-correct-comment-wrt-generic-flavor
+++ a/include/linux/interval_tree_generic.h
@@ -33,7 +33,7 @@
  * ITSTATIC:   'static' or empty
  * ITPREFIX:   prefix to use for the inline tree definitions
  *
- * Note - before using this, please consider if non-generic version
+ * Note - before using this, please consider if generic version
  * (interval_tree.h) would work for you...
  */
 
_

Patches currently in -mm which might be from dave@stgolabs.net are

rbtree-cache-leftmost-node-internally.patch
sched-fair-replace-cfs_rq-rb_leftmost.patch
sched-deadline-replace-earliest-dl-and-rq-leftmost-caching.patch
locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching.patch
block-cfq-replace-cfq_rb_root-leftmost-caching.patch
lib-interval_tree-fast-overlap-detection.patch
lib-interval-tree-correct-comment-wrt-generic-flavor.patch
procfs-use-faster-rb_first_cached.patch
fs-epoll-use-faster-rb_first_cached.patch

