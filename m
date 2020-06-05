From: akpm@linux-foundation.org
Subject: [merged]
 mm-page-writeback-fix-a-typo-in-comment-effictive-effective.patch removed
 from -mm tree
Date: Fri, 05 Jun 2020 13:18:44 -0700
Message-ID: <20200605201844.ac7Iuvbd_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728244AbgFEUSo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:18:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ethp@qq.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback: fix a typo in comment "effictive"->"effective"
has been removed from the -mm tree.  Its filename was
     mm-page-writeback-fix-a-typo-in-comment-effictive-effective.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from ethp@qq.com are
