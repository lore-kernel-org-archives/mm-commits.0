From: akpm@linux-foundation.org
Subject: [merged] mm-page_isolationc-fix-the-function-comments.patch
 removed from -mm tree
Date: Mon, 04 Apr 2016 11:09:49 -0700
Message-ID: <5702aded.8pJGc/7WxpFTf5Wi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56966 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653AbcDDSJu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2016 14:09:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilzhang1123@hotmail.com, js1304@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation.c: fix the function comments
has been removed from the -mm tree.  Its filename was
     mm-page_isolationc-fix-the-function-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Neil Zhang <neilzhang1123@hotmail.com>
Subject: mm/page_isolation.c: fix the function comments

commit fea85cff11de ("mm/page_isolation.c: return last tested pfn rather
than failure indicator") changed the meaning of the return value.
Let's change the function comments as well.

Signed-off-by: Neil Zhang <neilzhang1123@hotmail.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_isolation.c~mm-page_isolationc-fix-the-function-comments mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_isolationc-fix-the-function-comments
+++ a/mm/page_isolation.c
@@ -215,7 +215,7 @@ int undo_isolate_page_range(unsigned lon
  * all pages in [start_pfn...end_pfn) must be in the same zone.
  * zone->lock must be held before call this.
  *
- * Returns 1 if all pages in the range are isolated.
+ * Returns the last tested pfn.
  */
 static unsigned long
 __test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn,
_

Patches currently in -mm which might be from neilzhang1123@hotmail.com are


