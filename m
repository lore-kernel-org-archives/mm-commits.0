From: akpm@linux-foundation.org
Subject: + do_try_to_free_page-update-comments-related-to-vmscan-functions.patch added to -mm tree
Date: Tue, 29 Jul 2008 15:31:22 -0700
Message-ID: <200807292231.m6TMVM5F025252@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755441AbYG2WcT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 18:32:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@oss.ntt.co.jp, hugh@veritas.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     do_try_to_free_page: update comments related to vmscan functions
has been added to the -mm tree.  Its filename is
     do_try_to_free_page-update-comments-related-to-vmscan-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_try_to_free_page: update comments related to vmscan functions
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~do_try_to_free_page-update-comments-related-to-vmscan-functions mm/vmscan.c
--- a/mm/vmscan.c~do_try_to_free_page-update-comments-related-to-vmscan-functions
+++ a/mm/vmscan.c
@@ -1408,7 +1408,7 @@ static unsigned long do_try_to_free_page
 		if (sc->nr_scanned && priority < DEF_PRIORITY - 2)
 			congestion_wait(WRITE, HZ/10);
 	}
-	/* top priority shrink_caches still had more to do? don't OOM, then */
+	/* top priority shrink_zones still had more to do? don't OOM, then */
 	if (!sc->all_unreclaimable && scan_global_lru(sc))
 		ret = nr_reclaimed;
 out:
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

madvise-update-function-comment-of-madvise_dontneed.patch
swap-update-function-comment-of-release_pages.patch
swapfile-vmscan-update-comments-related-to-vmscan-functions.patch
do_try_to_free_page-update-comments-related-to-vmscan-functions.patch

