From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 059/127] mm/list_lru: fix a typo in comment
 "numbesr"->"numbers"
Date: Thu, 04 Jun 2020 16:49:19 -0700
Message-ID: <20200604234919.NJixOr819%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXtV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:49:21 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ethp@qq.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, rcampbell@nvidia.com, torvalds@linux-foundation.org

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
