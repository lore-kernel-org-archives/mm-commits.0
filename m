From: akpm@linux-foundation.org
Subject: [merged] rmap-fix-the-comment.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:38:20 -0700
Message-ID: <200910051838.n95IcKXE016759@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754714AbZJESj7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:39:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie8@gmail.com, hugh.dickins@tiscali.co.uk, mm-commits@vger.kernel.org


The patch titled
     mm/rmap.c: fix comment
has been removed from the -mm tree.  Its filename was
     rmap-fix-the-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/rmap.c: fix comment
From: Huang Shijie <shijie8@gmail.com>

The page_address_in_vma() is not only used in unuse_vma().

Signed-off-by: Huang Shijie <shijie8@gmail.com>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/rmap.c~rmap-fix-the-comment mm/rmap.c
--- a/mm/rmap.c~rmap-fix-the-comment
+++ a/mm/rmap.c
@@ -242,8 +242,8 @@ vma_address(struct page *page, struct vm
 }
 
 /*
- * At what user virtual address is page expected in vma? checking that the
- * page matches the vma: currently only used on anon pages, by unuse_vma;
+ * At what user virtual address is page expected in vma?
+ * checking that the page matches the vma.
  */
 unsigned long page_address_in_vma(struct page *page, struct vm_area_struct *vma)
 {
_

Patches currently in -mm which might be from shijie8@gmail.com are


