From: akpm@linux-foundation.org
Subject: [merged] mm-remove-annotation-of-gfp_mask-in-add_to_swap.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:36:08 -0700
Message-ID: <200906171836.n5HIa8Sb002092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756075AbZFQSpx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:45:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, hugh.dickins@tiscali.co.uk, mm-commits@vger.kernel.org


The patch titled
     mm: remove annotation of gfp_mask in add_to_swap
has been removed from the -mm tree.  Its filename was
     mm-remove-annotation-of-gfp_mask-in-add_to_swap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove annotation of gfp_mask in add_to_swap
From: Minchan Kim <minchan.kim@gmail.com>

Hugh removed add_to_swap's gfp_mask argument.  (mm: remove gfp_mask from
add_to_swap) So we have to remove annotation of gfp_mask of the function.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/swap_state.c~mm-remove-annotation-of-gfp_mask-in-add_to_swap mm/swap_state.c
--- a/mm/swap_state.c~mm-remove-annotation-of-gfp_mask-in-add_to_swap
+++ a/mm/swap_state.c
@@ -124,7 +124,6 @@ void __delete_from_swap_cache(struct pag
 /**
  * add_to_swap - allocate swap space for a page
  * @page: page we want to move to swap
- * @gfp_mask: memory allocation flags
  *
  * Allocate swap space for the page and add the page to the
  * swap cache.  Caller needs to hold the page lock. 
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
linux-next.patch
memcg-fix-lru-rotation-in-isolate_pages.patch

