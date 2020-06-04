From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 067/127] mm/memory: fix a typo in comment
 "attampt"->"attempt"
Date: Thu, 04 Jun 2020 16:49:43 -0700
Message-ID: <20200604234943.B3Xfi4WLk%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXto (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:49:44 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ethp@qq.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
