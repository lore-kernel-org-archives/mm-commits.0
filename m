From: akpm@linux-foundation.org
Subject: [merged] lib-rbtree-fix-coding-style-of-assignments.patch
 removed from -mm tree
Date: Tue, 07 Apr 2020 19:01:17 -0700
Message-ID: <20200408020117.2_f_KklWQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgDHCBS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:01:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chenqiwu@xiaomi.com, mm-commits@vger.kernel.org, walken@google.com


The patch titled
     Subject: lib/rbtree: fix coding style of assignments
has been removed from the -mm tree.  Its filename was
     lib-rbtree-fix-coding-style-of-assignments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: chenqiwu <chenqiwu@xiaomi.com>
Subject: lib/rbtree: fix coding style of assignments

Leave blank space between the right-hand and left-hand side of the
assignment to meet the kernel coding style better.

Link: http://lkml.kernel.org/r/1582621140-25850-1-git-send-email-qiwuchen55@gmail.com
Signed-off-by: chenqiwu <chenqiwu@xiaomi.com>
Reviewed-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree.c       |    4 ++--
 tools/lib/rbtree.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/lib/rbtree.c~lib-rbtree-fix-coding-style-of-assignments
+++ a/lib/rbtree.c
@@ -503,7 +503,7 @@ struct rb_node *rb_next(const struct rb_
 	if (node->rb_right) {
 		node = node->rb_right;
 		while (node->rb_left)
-			node=node->rb_left;
+			node = node->rb_left;
 		return (struct rb_node *)node;
 	}
 
@@ -535,7 +535,7 @@ struct rb_node *rb_prev(const struct rb_
 	if (node->rb_left) {
 		node = node->rb_left;
 		while (node->rb_right)
-			node=node->rb_right;
+			node = node->rb_right;
 		return (struct rb_node *)node;
 	}
 
--- a/tools/lib/rbtree.c~lib-rbtree-fix-coding-style-of-assignments
+++ a/tools/lib/rbtree.c
@@ -497,7 +497,7 @@ struct rb_node *rb_next(const struct rb_
 	if (node->rb_right) {
 		node = node->rb_right;
 		while (node->rb_left)
-			node=node->rb_left;
+			node = node->rb_left;
 		return (struct rb_node *)node;
 	}
 
@@ -528,7 +528,7 @@ struct rb_node *rb_prev(const struct rb_
 	if (node->rb_left) {
 		node = node->rb_left;
 		while (node->rb_right)
-			node=node->rb_right;
+			node = node->rb_right;
 		return (struct rb_node *)node;
 	}
 
_

Patches currently in -mm which might be from chenqiwu@xiaomi.com are
