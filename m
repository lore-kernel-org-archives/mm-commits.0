From: akpm@linux-foundation.org
Subject: [merged] lib-radix_tree-fix-error-in-docs-about-locks.patch
 removed from -mm tree
Date: Thu, 21 Jan 2016 14:59:09 -0800
Message-ID: <56a162bd.JtZxZtthFwrDPsNo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbcAUW7K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:59:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aurorean@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/radix-tree.h: fix error in docs about locks
has been removed from the -mm tree.  Its filename was
     lib-radix_tree-fix-error-in-docs-about-locks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Adam Barth <aurorean@gmail.com>
Subject: include/linux/radix-tree.h: fix error in docs about locks

This text refers to the "first 7 functions", which was correct when
written but became incorrect when Johannes Weiner added another function
to the list in 139e561660fe ("lib: radix_tree: tree node interface").

Change the text to correctly refer to the first 8 functions.

Signed-off-by: Adam Barth <aurorean@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/radix-tree.h~lib-radix_tree-fix-error-in-docs-about-locks include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~lib-radix_tree-fix-error-in-docs-about-locks
+++ a/include/linux/radix-tree.h
@@ -154,7 +154,7 @@ do {									\
  * radix_tree_gang_lookup_tag_slot
  * radix_tree_tagged
  *
- * The first 7 functions are able to be called locklessly, using RCU. The
+ * The first 8 functions are able to be called locklessly, using RCU. The
  * caller must ensure calls to these functions are made within rcu_read_lock()
  * regions. Other readers (lock-free or otherwise) and modifications may be
  * running concurrently.
_

Patches currently in -mm which might be from aurorean@gmail.com are


