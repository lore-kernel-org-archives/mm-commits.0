From: akpm@linux-foundation.org
Subject: [folded] mm-make-swap-token-dummies-static-inlines-fix-2.patch removed from -mm tree
Date: Mon, 21 Sep 2009 14:11:16 -0700
Message-ID: <200909212111.n8LLBG00016431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321AbZIUVLc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Sep 2009 17:11:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, randy.dunlap@oracle.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm-make-swap-token-dummies-static-inlines-fix-2.txt
has been removed from the -mm tree.  Its filename was
     mm-make-swap-token-dummies-static-inlines-fix-2.patch

This patch was dropped because it was folded into mm-make-swap-token-dummies-static-inlines.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-make-swap-token-dummies-static-inlines-fix-2.txt
From: Johannes Weiner <hannes@cmpxchg.org>

disable_swap_token() doesn't take an argument.  This fixes the
!CONFIG_SWAP dummy.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/swap.h~mm-make-swap-token-dummies-static-inlines-fix-2 include/linux/swap.h
--- a/include/linux/swap.h~mm-make-swap-token-dummies-static-inlines-fix-2
+++ a/include/linux/swap.h
@@ -454,7 +454,7 @@ static inline int has_swap_token(struct 
 	return 0;
 }
 
-static inline void disable_swap_token(struct mm_struct *mm)
+static inline void disable_swap_token(void)
 {
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-make-swap-token-dummies-static-inlines.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
mm-count-only-reclaimable-lru-pages-v2.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
mm-drop-unneeded-double-negations.patch
mm-introduce-page_lru_base_type.patch
mm-introduce-page_lru_base_type-fix.patch
mm-return-boolean-from-page_is_file_cache.patch
mm-return-boolean-from-page_has_private.patch
mm-document-is_page_cache_freeable.patch

