From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 065/127] mm/sparse: fix a typo in comment
 "convienence"->"convenience"
Date: Thu, 04 Jun 2020 16:49:37 -0700
Message-ID: <20200604234937.fXIIwMalK%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXti (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:49:38 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ethp@qq.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
