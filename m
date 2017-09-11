From: akpm@linux-foundation.org
Subject: [merged]
 lib-interval-tree-correct-comment-wrt-generic-flavor.patch removed from -mm
 tree
Date: Mon, 11 Sep 2017 12:42:01 -0700
Message-ID: <20170911194201.PIWLc4Jqk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50084 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbdIKTmC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:42:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org, peterz@infradead.org


The patch titled
     Subject: lib/interval-tree: correct comment wrt generic flavor
has been removed from the -mm tree.  Its filename was
     lib-interval-tree-correct-comment-wrt-generic-flavor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: lib/interval-tree: correct comment wrt generic flavor

interval_tree.h _is_ the generic flavor.

Link: http://lkml.kernel.org/r/20170719014603.19029-13-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
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


