From: akpm@linux-foundation.org
Subject: [merged] mm-vmalloc-fix-a-typo-in-comment.patch removed
 from -mm tree
Date: Tue, 07 Apr 2020 18:56:40 -0700
Message-ID: <20200408015640.oZCQndkin%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbgDHB4k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:56:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hqjagain@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: fix a typo in comment
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-a-typo-in-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qiujun Huang <hqjagain@gmail.com>
Subject: mm/vmalloc: fix a typo in comment

There is a typo in comment, fix it.
"exeeds" -> "exceeds"

Link: http://lkml.kernel.org/r/20200404060136.10838-1-hqjagain@gmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-a-typo-in-comment
+++ a/mm/vmalloc.c
@@ -3368,7 +3368,7 @@ retry:
 			goto overflow;
 
 		/*
-		 * If required width exeeds current VA block, move
+		 * If required width exceeds current VA block, move
 		 * base downwards and then recheck.
 		 */
 		if (base + end > va->va_end) {
_

Patches currently in -mm which might be from hqjagain@gmail.com are

mm-slab_common-fix-a-typo-in-comment-eariler-earlier.patch
