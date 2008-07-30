From: akpm@linux-foundation.org
Subject: - do_try_to_free_page-update-comments-related-to-vmscan-functions.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:15:13 -0700
Message-ID: <200807301915.m6UJFDwG011005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752647AbYG3TQI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:16:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fernando@oss.ntt.co.jp, hugh@veritas.com, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     do_try_to_free_page: update comments related to vmscan functions
has been removed from the -mm tree.  Its filename was
     do_try_to_free_page-update-comments-related-to-vmscan-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

