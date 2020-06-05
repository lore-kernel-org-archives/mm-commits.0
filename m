From: akpm@linux-foundation.org
Subject: [merged]
 mm-list_lru-fix-a-typo-in-comment-numbesr-numbers.patch removed from -mm
 tree
Date: Fri, 05 Jun 2020 13:18:30 -0700
Message-ID: <20200605201830.4E7LUtHQv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728041AbgFEUSa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:18:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ethp@qq.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com


The patch titled
     Subject: mm/list_lru: fix a typo in comment "numbesr"->"numbers"
has been removed from the -mm tree.  Its filename was
     mm-list_lru-fix-a-typo-in-comment-numbesr-numbers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ethon Paul <ethp@qq.com>
Subject: mm/list_lru: fix a typo in comment "numbesr"->"numbers"

There is a typo in comment, fix it.

Link: http://lkml.kernel.org/r/20200411071041.16161-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/list_lru.c~mm-list_lru-fix-a-typo-in-comment-numbesr-numbers
+++ a/mm/list_lru.c
@@ -213,7 +213,7 @@ restart:
 
 		/*
 		 * decrement nr_to_walk first so that we don't livelock if we
-		 * get stuck on large numbesr of LRU_RETRY items
+		 * get stuck on large numbers of LRU_RETRY items
 		 */
 		if (!*nr_to_walk)
 			break;
_

Patches currently in -mm which might be from ethp@qq.com are
