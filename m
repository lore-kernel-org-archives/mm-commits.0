From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 03/35] mm, slab_common: fix a typo in comment
 "eariler"->"earlier"
Date: Fri, 10 Apr 2020 14:32:22 -0700
Message-ID: <20200410213222.FouDg1Tsz%akpm@linux-foundation.org>
References: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgDJVcY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 17:32:24 -0400
In-Reply-To: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, hqjagain@gmail.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
