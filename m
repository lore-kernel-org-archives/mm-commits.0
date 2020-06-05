From: akpm@linux-foundation.org
Subject: [merged]
 mm-sparse-fix-a-typo-in-comment-convienence-convenience.patch removed from
 -mm tree
Date: Fri, 05 Jun 2020 13:18:42 -0700
Message-ID: <20200605201842.HMoMp7a0F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbgFEUSm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:18:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ethp@qq.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse: fix a typo in comment "convienence"->"convenience"
has been removed from the -mm tree.  Its filename was
     mm-sparse-fix-a-typo-in-comment-convienence-convenience.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ethon Paul <ethp@qq.com>
Subject: mm/sparse: fix a typo in comment "convienence"->"convenience"

There is a typo in comment, fix it.

Link: http://lkml.kernel.org/r/20200411002955.14545-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse.c~mm-sparse-fix-a-typo-in-comment-convienence-convenience
+++ a/mm/sparse.c
@@ -288,7 +288,7 @@ void __init memory_present(int nid, unsi
 
 /*
  * Mark all memblocks as present using memory_present(). This is a
- * convienence function that is useful for a number of arches
+ * convenience function that is useful for a number of arches
  * to mark all of the systems memory as present during initialization.
  */
 void __init memblocks_present(void)
_

Patches currently in -mm which might be from ethp@qq.com are
