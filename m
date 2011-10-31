From: akpm@linux-foundation.org
Subject: [folded] mm-zone_reclaim-make-isolate_lru_page-filter-aware-fix.patch removed from -mm tree
Date: Mon, 31 Oct 2011 16:41:14 -0700
Message-ID: <201110312341.p9VNfEC2030769@wpaz21.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:52307 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab1JaXmN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2011 19:42:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, aarcange@redhat.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, mm-co


The patch titled
     Subject: mm-zone_reclaim-make-isolate_lru_page-filter-aware-fix
has been removed from the -mm tree.  Its filename was
     mm-zone_reclaim-make-isolate_lru_page-filter-aware-fix.patch

This patch was dropped because it was folded into mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Minchan Kim <minchan.kim@gmail.com>
Subject: mm-zone_reclaim-make-isolate_lru_page-filter-aware-fix

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mmzone.h~mm-zone_reclaim-make-isolate_lru_page-filter-aware-fix include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-zone_reclaim-make-isolate_lru_page-filter-aware-fix
+++ a/include/linux/mmzone.h
@@ -171,7 +171,7 @@ static inline int is_unevictable_lru(enu
 /* Isolate clean file */
 #define ISOLATE_CLEAN		((__force isolate_mode_t)0x4)
 /* Isolate unmapped file */
-#define ISOLATE_UNMAPPED	((__force fmode_t)0x8)
+#define ISOLATE_UNMAPPED	((__force isolate_mode_t)0x8)
 
 /* LRU Isolation modes. */
 typedef unsigned __bitwise__ isolate_mode_t;
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

mm-compaction-trivial-clean-up-in-acct_isolated.patch
mm-change-isolate-mode-from-define-to-bitwise-type.patch
mm-compaction-make-isolate_lru_page-filter-aware.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch
mm-migration-clean-up-unmap_and_move.patch
vmscan-add-block-plug-for-page-reclaim.patch
mm-vmscan-drop-nr_force_scan-from-get_scan_count.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch
xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch
ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch
mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch
vmscan-count-pages-into-balanced-for-zone-with-good-watermark.patch
kswapd-assign-new_order-and-new_classzone_idx-after-wakeup-in-sleeping.patch
mm-compaction-make-compact_zone_order-static.patch
mm-disable-user-interface-to-manually-rescue-unevictable-pages.patch
vmscan-add-barrier-to-prevent-evictable-page-in-unevictable-list.patch
vmscan-limit-direct-reclaim-for-higher-order-allocations.patch
vmscan-limit-direct-reclaim-for-higher-order-allocations-fix.patch
vmscan-abort-reclaim-compaction-if-compaction-can-proceed.patch
mm-do-not-drain-pagevecs-for-mlockallmcl_future.patch

