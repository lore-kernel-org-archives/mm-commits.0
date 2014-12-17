From: akpm@linux-foundation.org
Subject: + rbtree-fix-typo-in-comment.patch added to -mm tree
Date: Wed, 17 Dec 2014 13:23:37 -0800
Message-ID: <5491f459.VDWIxAIbFouxUOES%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaLQVXi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Dec 2014 16:23:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: john@jjdev.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/rbtree.c: fix typo in comment
has been added to the -mm tree.  Its filename is
     rbtree-fix-typo-in-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rbtree-fix-typo-in-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rbtree-fix-typo-in-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John de la Garza <john@jjdev.com>
Subject: lib/rbtree.c: fix typo in comment

Signed-off-by: John de la Garza <john@jjdev.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rbtree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/rbtree.h~rbtree-fix-typo-in-comment include/linux/rbtree.h
--- a/include/linux/rbtree.h~rbtree-fix-typo-in-comment
+++ a/include/linux/rbtree.h
@@ -51,7 +51,7 @@ struct rb_root {
 
 #define RB_EMPTY_ROOT(root)  ((root)->rb_node == NULL)
 
-/* 'empty' nodes are nodes that are known not to be inserted in an rbree */
+/* 'empty' nodes are nodes that are known not to be inserted in an rbtree */
 #define RB_EMPTY_NODE(node)  \
 	((node)->__rb_parent_color == (unsigned long)(node))
 #define RB_CLEAR_NODE(node)  \
_

Patches currently in -mm which might be from john@jjdev.com are

origin.patch
rbtree-fix-typo-in-comment.patch

