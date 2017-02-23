From: akpm@linux-foundation.org
Subject: [merged] mm-fix-some-typos-in-mm-zsmallocc.patch removed from -mm tree
Date: Thu, 23 Feb 2017 13:16:03 -0800
Message-ID: <58af5113.h155X8WkWFZPeZA4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40440 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdBWVQE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:16:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix some typos in mm/zsmalloc.c
has been removed from the -mm tree.  Its filename was
     mm-fix-some-typos-in-mm-zsmallocc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm: fix some typos in mm/zsmalloc.c

Delete extra semicolon, and fix some typos.

Link: http://lkml.kernel.org/r/586F1823.4050107@huawei.com
Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/zsmalloc.c~mm-fix-some-typos-in-mm-zsmallocc mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-fix-some-typos-in-mm-zsmallocc
+++ a/mm/zsmalloc.c
@@ -25,7 +25,7 @@
  * Usage of struct page flags:
  *	PG_private: identifies the first component page
  *	PG_private2: identifies the last component page
- *	PG_owner_priv_1: indentifies the huge component page
+ *	PG_owner_priv_1: identifies the huge component page
  *
  */
 
@@ -364,7 +364,7 @@ static struct zspage *cache_alloc_zspage
 {
 	return kmem_cache_alloc(pool->zspage_cachep,
 			flags & ~(__GFP_HIGHMEM|__GFP_MOVABLE));
-};
+}
 
 static void cache_free_zspage(struct zs_pool *pool, struct zspage *zspage)
 {
@@ -2383,7 +2383,7 @@ struct zs_pool *zs_create_pool(const cha
 		goto err;
 
 	/*
-	 * Iterate reversly, because, size of size_class that we want to use
+	 * Iterate reversely, because, size of size_class that we want to use
 	 * for merging should be larger or equal to current size.
 	 */
 	for (i = zs_size_classes - 1; i >= 0; i--) {
_

Patches currently in -mm which might be from qiuxishi@huawei.com are


