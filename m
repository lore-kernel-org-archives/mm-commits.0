From: akpm@linux-foundation.org
Subject: [merged] mm-fix-kunmap_high-comment.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:11:22 -0700
Message-ID: <201111012111.pA1LBMUG013106@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15844 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab1KAVLZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:11:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: omycle@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix kunmap_high() comment
has been removed from the -mm tree.  Its filename was
     mm-fix-kunmap_high-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Li Haifeng <omycle@gmail.com>
Subject: mm: fix kunmap_high() comment

Signed-off-by: Li Haifeng <omycle@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/highmem.c~mm-fix-kunmap_high-comment mm/highmem.c
--- a/mm/highmem.c~mm-fix-kunmap_high-comment
+++ a/mm/highmem.c
@@ -250,7 +250,7 @@ void *kmap_high_get(struct page *page)
 #endif
 
 /**
- * kunmap_high - map a highmem page into memory
+ * kunmap_high - unmap a highmem page into memory
  * @page: &struct page to unmap
  *
  * If ARCH_NEEDS_KMAP_HIGH_GET is not defined then this may be called
_

Patches currently in -mm which might be from omycle@gmail.com are

origin.patch
linux-next.patch

