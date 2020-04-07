From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 010/166] mm/vmalloc: fix a typo in comment
Date: Mon, 06 Apr 2020 20:04:02 -0700
Message-ID: <20200407030402.QENMPeq3y%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgDGDEF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:04:05 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hqjagain@gmail.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
