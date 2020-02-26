From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-rbtree-fix-coding-style-of-assignments.patch added
 to -mm tree
Date: Tue, 25 Feb 2020 19:42:56 -0800
Message-ID: <20200226034256.FX2LAC0mk%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbgBZDm5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 Feb 2020 22:42:57 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chenqiwu@xiaomi.com, mm-commits@vger.kernel.org, walken@google.com


The patch titled
     Subject: lib/rbtree: fix coding style of assignments
has been added to the -mm tree.  Its filename is
     lib-rbtree-fix-coding-style-of-assignments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-rbtree-fix-coding-style-of-assignments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-rbtree-fix-coding-style-of-assignments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-slubc-replace-cpu_slab-partial-with-wrapped-apis.patch
mm-slubc-replace-kmem_cache-cpu_partial-with-wrapped-apis.patch
lib-rbtree-fix-coding-style-of-assignments.patch
