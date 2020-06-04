From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 063/127] mm: fix a typo in comment
 "strucure"->"structure"
Date: Thu, 04 Jun 2020 16:49:31 -0700
Message-ID: <20200604234931.Od3yqVXX_%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXtc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:49:32 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ethp@qq.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, rcampbell@nvidia.com, torvalds@linux-foundation.org

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
