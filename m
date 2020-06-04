From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 060/127] mm/filemap: fix a typo in comment
 "unneccssary"->"unnecessary"
Date: Thu, 04 Jun 2020 16:49:22 -0700
Message-ID: <20200604234922.SofsYH-7F%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXtX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:49:23 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ethp@qq.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, rcampbell@nvidia.com, torvalds@linux-foundation.org

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
