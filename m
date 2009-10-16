From: akpm@linux-foundation.org
Subject: + rmap-fix-the-comment-for-try_to_unmap_anon.patch added to -mm tree
Date: Fri, 16 Oct 2009 15:22:15 -0700
Message-ID: <200910162222.n9GMMFF4004620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750923AbZJPWWR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Oct 2009 18:22:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shijie8@gmail.com, hugh.dickins@tiscali.co.uk


The patch titled
     rmap: fix the comment for try_to_unmap_anon
has been added to the -mm tree.  Its filename is
     rmap-fix-the-comment-for-try_to_unmap_anon.patch

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
Subject: rmap: fix the comment for try_to_unmap_anon
From: Huang Shijie <shijie8@gmail.com>

Fix the comment for try_to_unmap_anon() with the new arguments.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

rmap-fix-the-comment-for-try_to_unmap_anon.patch

