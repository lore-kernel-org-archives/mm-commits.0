From: akpm@linux-foundation.org
Subject: [merged] mm-vmalloc-fix-a-typo-in-comment.patch removed
 from -mm tree
Date: Fri, 05 Jun 2020 13:17:13 -0700
Message-ID: <20200605201713.pYm15QGHr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728021AbgFEURO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:17:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, david@redhat.com, hch@lst.de, jtp.park@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: fix a typo in comment
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-a-typo-in-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeongtae Park <jtp.park@samsung.com>
Subject: mm/vmalloc: fix a typo in comment

There is a typo in comment, fix it.
"nother" -> "another"

Link: http://lkml.kernel.org/r/20200604185239.20765-1-jtp.park@samsung.com
Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-a-typo-in-comment
+++ a/mm/vmalloc.c
@@ -2317,7 +2317,7 @@ static inline void __vfree_deferred(cons
 	 * Use raw_cpu_ptr() because this can be called from preemptible
 	 * context. Preemption is absolutely fine here, because the llist_add()
 	 * implementation is lockless, so it works even if we are adding to
-	 * nother cpu's list.  schedule_work() should be fine with this too.
+	 * another cpu's list. schedule_work() should be fine with this too.
 	 */
 	struct vfree_deferred *p = raw_cpu_ptr(&vfree_deferred);
 
_

Patches currently in -mm which might be from jtp.park@samsung.com are
