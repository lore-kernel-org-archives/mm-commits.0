From: akpm@linux-foundation.org
Subject: [folded-merged]
 rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch removed from -mm tree
Date: Fri, 06 Nov 2015 16:15:26 -0800
Message-ID: <563d429e.lpE2UHSRGQd4rKUH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbbKGAP1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 19:15:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dev@codyps.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix
has been removed from the -mm tree.  Its filename was
     rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch

This patch was dropped because it was folded into rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix

s/this function/rbtree_postorder_for_each_entry_safe()/ (it isn't a function!)

Cc: Cody P Schafer <dev@codyps.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rbtree.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/rbtree.h~rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix include/linux/rbtree.h
--- a/include/linux/rbtree.h~rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix
+++ a/include/linux/rbtree.h
@@ -109,9 +109,9 @@ static inline void rb_link_node_rcu(stru
  * @root:	'rb_root *' of the rbtree.
  * @field:	the name of the rb_node field within 'type'.
  *
- * This function provides a similar guarantee as list_for_each_entry_safe() and
- * allows the iteration to continue independent of changes to @pos by the body
- * of the loop.
+ * rbtree_postorder_for_each_entry_safe() provides a similar guarantee as
+ * list_for_each_entry_safe() and allows the iteration to continue independent
+ * of changes to @pos by the body of the loop.
  *
  * Note, however, that it cannot handle other modifications that re-order the
  * rbtree it is iterating over. This includes calling rb_erase() on @pos, as
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-reflow-comment.patch
mm-memcontrolc-uninline-mem_cgroup_usage.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch

