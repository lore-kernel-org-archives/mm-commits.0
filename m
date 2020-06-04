From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 057/127] mm/compaction: fix a typo in comment
 "pessemistic"->"pessimistic"
Date: Thu, 04 Jun 2020 16:49:13 -0700
Message-ID: <20200604234913.vqdYXIOMX%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXtO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:49:14 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ethp@qq.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, rcampbell@nvidia.com, torvalds@linux-foundation.org

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
