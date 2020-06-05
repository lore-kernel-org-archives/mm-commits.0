From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-a-typo-in-comment-strucure-structure.patch removed from -mm tree
Date: Fri, 05 Jun 2020 13:18:38 -0700
Message-ID: <20200605201838.jtK_zGpZd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728041AbgFEUSj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:18:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ethp@qq.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com


The patch titled
     Subject: mm: fix a typo in comment "strucure"->"structure"
has been removed from the -mm tree.  Its filename was
     mm-fix-a-typo-in-comment-strucure-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ethon Paul <ethp@qq.com>
Subject: mm: fix a typo in comment "strucure"->"structure"

There is a typo in comment, fix it.

Link: http://lkml.kernel.org/r/20200411064723.15855-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/internal.h~mm-fix-a-typo-in-comment-strucure-structure
+++ a/mm/internal.h
@@ -132,7 +132,7 @@ extern pmd_t *mm_find_pmd(struct mm_stru
  *
  * zonelist, preferred_zone and highest_zoneidx are set first in
  * __alloc_pages_nodemask() for the fast path, and might be later changed
- * in __alloc_pages_slowpath(). All other functions pass the whole strucure
+ * in __alloc_pages_slowpath(). All other functions pass the whole structure
  * by a const pointer.
  */
 struct alloc_context {
_

Patches currently in -mm which might be from ethp@qq.com are
