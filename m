From: akpm@linux-foundation.org
Subject: + rmap-fix-the-comment.patch added to -mm tree
Date: Tue, 29 Sep 2009 12:58:49 -0700
Message-ID: <200909291958.n8TJwnZU024073@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753818AbZI2T7Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 15:59:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shijie8@gmail.com, hugh.dickins@tiscali.co.uk


The patch titled
     mm/rmap.c: fix comment
has been added to the -mm tree.  Its filename is
     rmap-fix-the-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

rmap-fix-the-comment.patch

