From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 122/166] lib/rbtree: fix coding style of
 assignments
Date: Mon, 06 Apr 2020 20:10:31 -0700
Message-ID: <20200407031031.KyIx4qL9f%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgDGDKe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:10:34 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chenqiwu@xiaomi.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, walken@google.com

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
