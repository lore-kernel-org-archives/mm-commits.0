From: akpm@linux-foundation.org
Subject: [merged]
 mm-slub-fix-a-typo-in-comment-disambiguiation-disambiguation.patch removed
 from -mm tree
Date: Fri, 05 Jun 2020 13:18:40 -0700
Message-ID: <20200605201840._rpQAOLuA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727917AbgFEUSk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:18:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ethp@qq.com, mm-commits@vger.kernel.org, rientjes@google.com


The patch titled
     Subject: mm/slub: fix a typo in comment "disambiguiation"->"disambiguation"
has been removed from the -mm tree.  Its filename was
     mm-slub-fix-a-typo-in-comment-disambiguiation-disambiguation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ethon Paul <ethp@qq.com>
Subject: mm/slub: fix a typo in comment "disambiguiation"->"disambiguation"

There is a typo in comment, fix it.

Link: http://lkml.kernel.org/r/20200411002247.14468-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-fix-a-typo-in-comment-disambiguiation-disambiguation
+++ a/mm/slub.c
@@ -2013,7 +2013,7 @@ static void *get_partial(struct kmem_cac
 
 #ifdef CONFIG_PREEMPTION
 /*
- * Calculate the next globally unique transaction for disambiguiation
+ * Calculate the next globally unique transaction for disambiguation
  * during cmpxchg. The transactions start with the cpu number and are then
  * incremented by CONFIG_NR_CPUS.
  */
_

Patches currently in -mm which might be from ethp@qq.com are
