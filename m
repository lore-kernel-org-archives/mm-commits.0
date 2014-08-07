From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-fix-an-outdated-comment-still-mentioning-get_scan_ratio.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:06:25 -0700
Message-ID: <53e3dc41.GCzmgqY6vMK8Ogv2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f201.google.com ([209.85.160.201]:57940 "EHLO
	mail-yk0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbaHGUG0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:06:26 -0400
Received: by mail-yk0-f201.google.com with SMTP id 142so610456ykq.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:06:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmarchan@redhat.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: fix an outdated comment still mentioning get_scan_ratio
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-an-outdated-comment-still-mentioning-get_scan_ratio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Jerome Marchand" <jmarchan@redhat.com>
Subject: mm, vmscan: fix an outdated comment still mentioning get_scan_ratio

Quite a while ago, get_scan_ratio() has been renamed get_scan_count(),
however a comment in shrink_active_list() still mention it.  This patch
fixes the outdated comment.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-fix-an-outdated-comment-still-mentioning-get_scan_ratio mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-fix-an-outdated-comment-still-mentioning-get_scan_ratio
+++ a/mm/vmscan.c
@@ -1756,7 +1756,7 @@ static void shrink_active_list(unsigned
 	 * Count referenced pages from currently used mappings as rotated,
 	 * even though only some of them are actually re-activated.  This
 	 * helps balance scan pressure between file and anonymous pages in
-	 * get_scan_ratio.
+	 * get_scan_count.
 	 */
 	reclaim_stat->recent_rotated[file] += nr_rotated;
 
_

Patches currently in -mm which might be from jmarchan@redhat.com are

origin.patch

