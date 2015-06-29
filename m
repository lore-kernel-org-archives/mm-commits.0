From: akpm@linux-foundation.org
Subject: [merged]
 kasan-remove-duplicate-definition-of-the-macro-kasan_free_page.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:49:05 -0700
Message-ID: <5591af41.XKwQhq1xixI/LIKW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560AbbF2UtG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:49:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: long.wanglong@huawei.com, a.ryabinin@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: remove duplicate definition of the macro KASAN_FREE_PAGE
has been removed from the -mm tree.  Its filename was
     kasan-remove-duplicate-definition-of-the-macro-kasan_free_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang Long <long.wanglong@huawei.com>
Subject: kasan: remove duplicate definition of the macro KASAN_FREE_PAGE

Remove duplicate definition of the macro KASAN_FREE_PAGE in
mm/kasan/kasan.h

Signed-off-by: Wang Long <long.wanglong@huawei.com>
Acked-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/kasan/kasan.h~kasan-remove-duplicate-definition-of-the-macro-kasan_free_page mm/kasan/kasan.h
--- a/mm/kasan/kasan.h~kasan-remove-duplicate-definition-of-the-macro-kasan_free_page
+++ a/mm/kasan/kasan.h
@@ -7,7 +7,6 @@
 #define KASAN_SHADOW_MASK       (KASAN_SHADOW_SCALE_SIZE - 1)
 
 #define KASAN_FREE_PAGE         0xFF  /* page was freed */
-#define KASAN_FREE_PAGE         0xFF  /* page was freed */
 #define KASAN_PAGE_REDZONE      0xFE  /* redzone for kmalloc_large allocations */
 #define KASAN_KMALLOC_REDZONE   0xFC  /* redzone inside slub object */
 #define KASAN_KMALLOC_FREE      0xFB  /* object was freed (kmem_cache_free/kfree) */
_

Patches currently in -mm which might be from long.wanglong@huawei.com are

origin.patch

