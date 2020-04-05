From: akpm@linux-foundation.org
Subject: +
 mm-slab_common-fix-a-typo-in-comment-eariler-earlier.patch added to -mm
 tree
Date: Sun, 05 Apr 2020 15:06:46 -0700
Message-ID: <20200405220646.yNEC5SI3d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbgDEWGr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 5 Apr 2020 18:06:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hqjagain@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slab_common: Fix a typo in comment "eariler"->"earlier"
has been added to the -mm tree.  Its filename is
     mm-slab_common-fix-a-typo-in-comment-eariler-earlier.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab_common-fix-a-typo-in-comment-eariler-earlier.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab_common-fix-a-typo-in-comment-eariler-earlier.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qiujun Huang <hqjagain@gmail.com>
Subject: mm, slab_common: Fix a typo in comment "eariler"->"earlier"

There is a typo in comment, fix it.
s/eariler/earlier/

Link: http://lkml.kernel.org/r/20200405160544.1246-1-hqjagain@gmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-slab_common-fix-a-typo-in-comment-eariler-earlier.patch
kmod-fix-a-typo-assuems-assumes.patch
lib-kconfigdebug-fix-a-typo-capabilitiy-capability.patch
