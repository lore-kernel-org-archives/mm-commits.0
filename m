From: akpm@linux-foundation.org
Subject: [merged]
 mm-filemap-fix-a-typo-in-comment-unneccssary-unnecessary.patch removed from
 -mm tree
Date: Fri, 05 Jun 2020 13:18:32 -0700
Message-ID: <20200605201832.K8MGASxm6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728041AbgFEUSc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:18:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ethp@qq.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com


The patch titled
     Subject: mm/filemap: fix a typo in comment "unneccssary"->"unnecessary"
has been removed from the -mm tree.  Its filename was
     mm-filemap-fix-a-typo-in-comment-unneccssary-unnecessary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ethon Paul <ethp@qq.com>
Subject: mm/filemap: fix a typo in comment "unneccssary"->"unnecessary"

There is a typo in comment, fix it.

Link: http://lkml.kernel.org/r/20200411065141.15936-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-fix-a-typo-in-comment-unneccssary-unnecessary
+++ a/mm/filemap.c
@@ -1256,7 +1256,7 @@ EXPORT_SYMBOL_GPL(add_page_wait_queue);
  * instead.
  *
  * The read of PG_waiters has to be after (or concurrently with) PG_locked
- * being cleared, but a memory barrier should be unneccssary since it is
+ * being cleared, but a memory barrier should be unnecessary since it is
  * in the same byte as PG_locked.
  */
 static inline bool clear_bit_unlock_is_negative_byte(long nr, volatile void *mem)
_

Patches currently in -mm which might be from ethp@qq.com are
