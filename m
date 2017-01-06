From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-fix-typo-of-cache_alloc_zspage.patch removed
 from -mm tree
Date: Fri, 06 Jan 2017 13:57:48 -0800
Message-ID: <587012dc.T0Eszk6wgdTC/9yZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54864 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751423AbdAFV42 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jan 2017 16:56:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix typo ni cache_alloc_zspage()
has been removed from the -mm tree.  Its filename was
     mm-fix-typo-of-cache_alloc_zspage.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm: fix typo ni cache_alloc_zspage()

Delete extra semicolon, it was introduced in 3783689 ("zsmalloc: introduce
zspage structure").

Link: http://lkml.kernel.org/r/5864C12F.60709@huawei.com
Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zsmalloc.c~mm-fix-typo-of-cache_alloc_zspage mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-fix-typo-of-cache_alloc_zspage
+++ a/mm/zsmalloc.c
@@ -364,7 +364,7 @@ static struct zspage *cache_alloc_zspage
 {
 	return kmem_cache_alloc(pool->zspage_cachep,
 			flags & ~(__GFP_HIGHMEM|__GFP_MOVABLE));
-};
+}
 
 static void cache_free_zspage(struct zs_pool *pool, struct zspage *zspage)
 {
_

Patches currently in -mm which might be from qiuxishi@huawei.com are


