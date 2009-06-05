From: akpm@linux-foundation.org
Subject: + mm-remove-annotation-of-gfp_mask-in-add_to_swap.patch added to -mm tree
Date: Fri, 05 Jun 2009 13:28:40 -0700
Message-ID: <200906052028.n55KSeiV031916@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751005AbZFEU2n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Jun 2009 16:28:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, hugh.dickins@tiscali.co.uk


The patch titled
     mm: remove annotation of gfp_mask in add_to_swap
has been added to the -mm tree.  Its filename is
     mm-remove-annotation-of-gfp_mask-in-add_to_swap.patch

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

linux-next.patch
vmscan-zvc-updates-in-shrink_active_list-can-be-done-once.patch
mm-setup_per_zone_inactive_ratio-fix-comment-and-make-it-__init.patch
vmscan-prevent-shrinking-of-active-anon-lru-list-in-case-of-no-swap-space-v3.patch
page-allocator-clean-up-functions-related-to-pages_min.patch
page-allocator-clean-up-functions-related-to-pages_min-checkpatch-fixes.patch
page-allocator-add-inactive-ratio-calculation-function-of-each-zone.patch
page-allocator-add-inactive-ratio-calculation-function-of-each-zone-checkpatch-fixes.patch
page-allocator-reset-wmark_min-and-inactive-ratio-of-zone-when-hotplug-happens.patch
mm-remove-config_unevictable_lru-config-option.patch
mm-remove-annotation-of-gfp_mask-in-add_to_swap.patch
use-printk_once-in-several-places.patch
use-printk_once-in-several-places-clean-up-printk_once-of-get_cpu_vendor.patch

