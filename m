From: akpm@linux-foundation.org
Subject: [merged] mm-frontswap-fix-some-typos-in-frontswapc.patch
 removed from -mm tree
Date: Fri, 05 Jun 2020 13:18:34 -0700
Message-ID: <20200605201834.dSdKlgzp2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728041AbgFEUSf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:18:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ethp@qq.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/frontswap: fix some typos in frontswap.c
has been removed from the -mm tree.  Its filename was
     mm-frontswap-fix-some-typos-in-frontswapc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ethon Paul <ethp@qq.com>
Subject: mm/frontswap: fix some typos in frontswap.c

There are some typos in comment, fix them.

s/Fortunatly/Fortunately
s/taked/taken
s/necessory/necessary
s/shink/shrink

Link: http://lkml.kernel.org/r/20200411064009.15727-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/frontswap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/frontswap.c~mm-frontswap-fix-some-typos-in-frontswapc
+++ a/mm/frontswap.c
@@ -87,7 +87,7 @@ static inline void inc_frontswap_invalid
  *
  * This would not guards us against the user deciding to call swapoff right as
  * we are calling the backend to initialize (so swapon is in action).
- * Fortunatly for us, the swapon_mutex has been taked by the callee so we are
+ * Fortunately for us, the swapon_mutex has been taken by the callee so we are
  * OK. The other scenario where calls to frontswap_store (called via
  * swap_writepage) is racing with frontswap_invalidate_area (called via
  * swapoff) is again guarded by the swap subsystem.
@@ -413,8 +413,8 @@ static int __frontswap_unuse_pages(unsig
 }
 
 /*
- * Used to check if it's necessory and feasible to unuse pages.
- * Return 1 when nothing to do, 0 when need to shink pages,
+ * Used to check if it's necessary and feasible to unuse pages.
+ * Return 1 when nothing to do, 0 when need to shrink pages,
  * error code when there is an error.
  */
 static int __frontswap_shrink(unsigned long target_pages,
_

Patches currently in -mm which might be from ethp@qq.com are
