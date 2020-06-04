From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 025/127] mm/vmalloc: fix a typo in comment
Date: Thu, 04 Jun 2020 16:47:19 -0700
Message-ID: <20200604234719.eyPH8lSn6%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgFDXrV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:47:21 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, david@redhat.com, hch@lst.de, jtp.park@samsung.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
