From: akpm@linux-foundation.org
Subject: [merged]
 mm-memblock-fix-a-typo-in-comment-implict-implicit.patch removed from -mm
 tree
Date: Fri, 05 Jun 2020 13:18:28 -0700
Message-ID: <20200605201828.-_kQS3PJt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728041AbgFEUS2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:18:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ethp@qq.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com


The patch titled
     Subject: mm/memblock: fix a typo in comment "implict"->"implicit"
has been removed from the -mm tree.  Its filename was
     mm-memblock-fix-a-typo-in-comment-implict-implicit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from ethp@qq.com are
