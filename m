From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory-fix-a-typo-in-comment-attampt-attempt.patch removed from -mm tree
Date: Fri, 05 Jun 2020 13:18:46 -0700
Message-ID: <20200605201846.QEKRc83r8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728129AbgFEUSr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:18:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ethp@qq.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory: fix a typo in comment "attampt"->"attempt"
has been removed from the -mm tree.  Its filename was
     mm-memory-fix-a-typo-in-comment-attampt-attempt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ethon Paul <ethp@qq.com>
Subject: mm/memory: fix a typo in comment "attampt"->"attempt"

There is a comment in typo, fix it.

Link: http://lkml.kernel.org/r/20200411004043.14686-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-fix-a-typo-in-comment-attampt-attempt
+++ a/mm/memory.c
@@ -2467,7 +2467,7 @@ static inline bool cow_user_page(struct
 		}
 
 		/*
-		 * The same page can be mapped back since last copy attampt.
+		 * The same page can be mapped back since last copy attempt.
 		 * Try to copy again under PTL.
 		 */
 		if (__copy_from_user_inatomic(kaddr, uaddr, PAGE_SIZE)) {
_

Patches currently in -mm which might be from ethp@qq.com are
