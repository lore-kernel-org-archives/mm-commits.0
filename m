From: akpm@linux-foundation.org
Subject: [merged]
 mm-slab_common-fix-a-typo-in-comment-eariler-earlier.patch removed from -mm
 tree
Date: Sat, 11 Apr 2020 23:44:34 -0700
Message-ID: <20200412064434.8dup6QQna%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbgDLGof (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 12 Apr 2020 02:44:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, hqjagain@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slab_common: fix a typo in comment "eariler"->"earlier"
has been removed from the -mm tree.  Its filename was
     mm-slab_common-fix-a-typo-in-comment-eariler-earlier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qiujun Huang <hqjagain@gmail.com>
Subject: mm, slab_common: fix a typo in comment "eariler"->"earlier"

There is a typo in comment, fix it.
s/eariler/earlier/

Link: http://lkml.kernel.org/r/20200405160544.1246-1-hqjagain@gmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slab_common.c~mm-slab_common-fix-a-typo-in-comment-eariler-earlier
+++ a/mm/slab_common.c
@@ -731,7 +731,7 @@ static void kmemcg_rcufn(struct rcu_head
 	/*
 	 * We need to grab blocking locks.  Bounce to ->work.  The
 	 * work item shares the space with the RCU head and can't be
-	 * initialized eariler.
+	 * initialized earlier.
 	 */
 	INIT_WORK(&s->memcg_params.work, kmemcg_workfn);
 	queue_work(memcg_kmem_cache_wq, &s->memcg_params.work);
_

Patches currently in -mm which might be from hqjagain@gmail.com are
