From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 058/127] mm/memblock: fix a typo in comment
 "implict"->"implicit"
Date: Thu, 04 Jun 2020 16:49:16 -0700
Message-ID: <20200604234916.vTuJe6qC7%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXtR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:49:17 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ethp@qq.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, rcampbell@nvidia.com, torvalds@linux-foundation.org

From: Ethon Paul <ethp@qq.com>
Subject: mm/memblock: fix a typo in comment "implict"->"implicit"

There is a typo in commet, fix it.

Link: http://lkml.kernel.org/r/20200411070701.16097-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memblock.c~mm-memblock-fix-a-typo-in-comment-implict-implicit
+++ a/mm/memblock.c
@@ -78,7 +78,7 @@
  * * memblock_alloc*() - these functions return the **virtual** address
  *   of the allocated memory.
  *
- * Note, that both API variants use implict assumptions about allowed
+ * Note, that both API variants use implicit assumptions about allowed
  * memory ranges and the fallback methods. Consult the documentation
  * of memblock_alloc_internal() and memblock_alloc_range_nid()
  * functions for more elaborate description.
_
