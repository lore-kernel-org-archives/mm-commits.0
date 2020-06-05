From: akpm@linux-foundation.org
Subject: [merged]
 mm-mmap-fix-a-typo-in-comment-compatbility-compatibility.patch removed from
 -mm tree
Date: Fri, 05 Jun 2020 13:18:20 -0700
Message-ID: <20200605201820.lTt58Hc9U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728126AbgFEUSV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:18:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ethp@qq.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com


The patch titled
     Subject: mm: mmap: fix a typo in comment "compatbility"->"compatibility"
has been removed from the -mm tree.  Its filename was
     mm-mmap-fix-a-typo-in-comment-compatbility-compatibility.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ethon Paul <ethp@qq.com>
Subject: mm: mmap: fix a typo in comment "compatbility"->"compatibility"

There is a typo in comment, fix it.

Link: http://lkml.kernel.org/r/20200410163206.14016-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmap-fix-a-typo-in-comment-compatbility-compatibility
+++ a/mm/mmap.c
@@ -1207,7 +1207,7 @@ struct vm_area_struct *vma_merge(struct
 }
 
 /*
- * Rough compatbility check to quickly see if it's even worth looking
+ * Rough compatibility check to quickly see if it's even worth looking
  * at sharing an anon_vma.
  *
  * They need to have the same vm_file, and the flags can only differ
_

Patches currently in -mm which might be from ethp@qq.com are
