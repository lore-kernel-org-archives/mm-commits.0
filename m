From: akpm@linux-foundation.org
Subject: [merged] rbtree-fix-typo-in-comment.patch removed from -mm tree
Date: Wed, 18 Feb 2015 11:43:22 -0800
Message-ID: <54e4eb5a.2Fv8RFGQ2iQVNI2H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46069 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784AbbBRTnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:43:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: john@jjdev.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/rbtree.c: fix typo in comment
has been removed from the -mm tree.  Its filename was
     rbtree-fix-typo-in-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

