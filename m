From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-update-the-comment-of-should_continue_reclaim.patch added to -mm
 tree
Date: Fri, 01 May 2020 14:55:17 -0700
Message-ID: <20200501215517.nBHXFiLOI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgEAVzS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 1 May 2020 17:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chenqiwu@xiaomi.com, mm-commits@vger.kernel.org, qiwuchen55@gmail.com


The patch titled
     Subject: mm/vmscan: update the comment of should_continue_reclaim()
has been added to the -mm tree.  Its filename is
     mm-vmscan-update-the-comment-of-should_continue_reclaim.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-update-the-comment-of-should_continue_reclaim.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-update-the-comment-of-should_continue_reclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qiwu Chen <qiwuchen55@gmail.com>
Subject: mm/vmscan: update the comment of should_continue_reclaim()

try_to_compact_zone() has been replaced by try_to_compact_pages(), which
is necessary to be updated in the comment of should_continue_reclaim().

Link: http://lkml.kernel.org/r/20200501034907.22991-1-chenqiwu@xiaomi.com
Signed-off-by: Qiwu Chen <chenqiwu@xiaomi.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-update-the-comment-of-should_continue_reclaim
+++ a/mm/vmscan.c
@@ -2577,7 +2577,7 @@ static bool in_reclaim_compaction(struct
  * Reclaim/compaction is used for high-order allocation requests. It reclaims
  * order-0 pages before compacting the zone. should_continue_reclaim() returns
  * true if more pages should be reclaimed such that when the page allocator
- * calls try_to_compact_zone() that it will have enough free pages to succeed.
+ * calls try_to_compact_pages() that it will have enough free pages to succeed.
  * It will give up earlier than that if there is difficulty reclaiming pages.
  */
 static inline bool should_continue_reclaim(struct pglist_data *pgdat,
_

Patches currently in -mm which might be from qiwuchen55@gmail.com are

mm-vmscan-remove-unnecessary-argument-description-of-isolate_lru_pages.patch
mm-vmscan-update-the-comment-of-should_continue_reclaim.patch
