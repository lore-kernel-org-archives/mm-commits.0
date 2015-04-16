From: akpm@linux-foundation.org
Subject: [merged] mm-zsmallocc-fix-comment-for-get_pages_per_zspage.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:53:42 -0700
Message-ID: <552fe916.Miu0EYwIYTsWirbE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42976 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbbDPQsN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:48:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghao.xie@samsung.com, minchan@kernel.org, yinghao.xie@sumsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc.c: fix comment for get_pages_per_zspage
has been removed from the -mm tree.  Its filename was
     mm-zsmallocc-fix-comment-for-get_pages_per_zspage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yinghao Xie <yinghao.xie@samsung.com>
Subject: mm/zsmalloc.c: fix comment for get_pages_per_zspage

Signed-off-by: Yinghao Xie <yinghao.xie@sumsung.com>
Suggested-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/zsmalloc.c~mm-zsmallocc-fix-comment-for-get_pages_per_zspage mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmallocc-fix-comment-for-get_pages_per_zspage
+++ a/mm/zsmalloc.c
@@ -731,7 +731,8 @@ out:
  * to form a zspage for each size class. This is important
  * to reduce wastage due to unusable space left at end of
  * each zspage which is given as:
- *	wastage = Zp - Zp % size_class
+ *     wastage = Zp % class_size
+ *     usage = Zp - wastage
  * where Zp = zspage size = k * PAGE_SIZE where k = 1, 2, ...
  *
  * For example, for size class of 3/8 * PAGE_SIZE, we should
_

Patches currently in -mm which might be from yinghao.xie@samsung.com are

origin.patch

