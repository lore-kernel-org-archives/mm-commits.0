From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 066/127] mm/page-writeback: fix a typo in comment
 "effictive"->"effective"
Date: Thu, 04 Jun 2020 16:49:40 -0700
Message-ID: <20200604234940.gjiMozXDe%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXtm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:49:42 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ethp@qq.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Ethon Paul <ethp@qq.com>
Subject: mm/page-writeback: fix a typo in comment "effictive"->"effective"

There is a typo in comment, fix it.

Link: http://lkml.kernel.org/r/20200411003513.14613-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page-writeback.c~mm-page-writeback-fix-a-typo-in-comment-effictive-effective
+++ a/mm/page-writeback.c
@@ -257,7 +257,7 @@ static void wb_min_max_ratio(struct bdi_
  * requiring writeback.
  *
  * This number of dirtyable pages is the base value of which the
- * user-configurable dirty ratio is the effictive number of pages that
+ * user-configurable dirty ratio is the effective number of pages that
  * are allowed to be actually dirtied.  Per individual zone, or
  * globally by using the sum of dirtyable pages over all zones.
  *
_
