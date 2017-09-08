From: akpm@linux-foundation.org
Subject: [patch 077/126] lib/interval-tree: correct comment wrt
 generic flavor
Date: Fri, 08 Sep 2017 16:15:12 -0700
Message-ID: <20170908231512.HKhBCZxhX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52926 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753026AbdIHXPN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:15:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org, peterz@infradead.org, torvalds@linux-foundation.org

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
