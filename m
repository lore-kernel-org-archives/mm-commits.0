From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-fix-a-typo-in-comment-pessemistic-pessimistic.patch removed
 from -mm tree
Date: Fri, 05 Jun 2020 13:18:26 -0700
Message-ID: <20200605201826.T5aMQy7Gx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728041AbgFEUS0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:18:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ethp@qq.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com


The patch titled
     Subject: mm/compaction: fix a typo in comment "pessemistic"->"pessimistic"
has been removed from the -mm tree.  Its filename was
     mm-compaction-fix-a-typo-in-comment-pessemistic-pessimistic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ethon Paul <ethp@qq.com>
Subject: mm/compaction: fix a typo in comment "pessemistic"->"pessimistic"

There is a typo in comment, fix it.

Link: http://lkml.kernel.org/r/20200411070307.16021-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-fix-a-typo-in-comment-pessemistic-pessimistic
+++ a/mm/compaction.c
@@ -1401,7 +1401,7 @@ fast_isolate_freepages(struct compact_co
 		if (scan_start) {
 			/*
 			 * Use the highest PFN found above min. If one was
-			 * not found, be pessemistic for direct compaction
+			 * not found, be pessimistic for direct compaction
 			 * and use the min mark.
 			 */
 			if (highest) {
_

Patches currently in -mm which might be from ethp@qq.com are
