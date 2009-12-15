From: akpm@linux-foundation.org
Subject: [merged] rmap-fix-the-comment-for-try_to_unmap_anon.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:52:06 -0800
Message-ID: <200912152152.nBFLq67f015159@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761173AbZLOVwk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:52:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie8@gmail.com, hugh.dickins@tiscali.co.uk, mm-commits@vger.kernel.org


The patch titled
     rmap: fix the comment for try_to_unmap_anon
has been removed from the -mm tree.  Its filename was
     rmap-fix-the-comment-for-try_to_unmap_anon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rmap: fix the comment for try_to_unmap_anon
From: Huang Shijie <shijie8@gmail.com>

Fix the comment for try_to_unmap_anon() with the new arguments.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/rmap.c~rmap-fix-the-comment-for-try_to_unmap_anon mm/rmap.c
--- a/mm/rmap.c~rmap-fix-the-comment-for-try_to_unmap_anon
+++ a/mm/rmap.c
@@ -1001,8 +1001,7 @@ static int try_to_mlock_page(struct page
  * try_to_unmap_anon - unmap or unlock anonymous page using the object-based
  * rmap method
  * @page: the page to unmap/unlock
- * @unlock:  request for unlock rather than unmap [unlikely]
- * @migration:  unmapping for migration - ignored if @unlock
+ * @flags: action and flags
  *
  * Find all the mappings of a page using the mapping pointer and the vma chains
  * contained in the anon_vma struct it points to.
_

Patches currently in -mm which might be from shijie8@gmail.com are

origin.patch

