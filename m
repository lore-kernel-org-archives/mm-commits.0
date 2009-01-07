From: akpm@linux-foundation.org
Subject: - mm-kill-zone_is_near_oom.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:13:51 -0800
Message-ID: <200901072213.n07MDp6W013867@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757310AbZAGWNy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:13:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: kill zone_is_near_oom()
has been removed from the -mm tree.  Its filename was
     mm-kill-zone_is_near_oom.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: kill zone_is_near_oom()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

zone_is_near_oom() is unused.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/vmscan.c~mm-kill-zone_is_near_oom mm/vmscan.c
--- a/mm/vmscan.c~mm-kill-zone_is_near_oom
+++ a/mm/vmscan.c
@@ -1167,11 +1167,6 @@ static inline void note_zone_scanning_pr
 		zone->prev_priority = priority;
 }
 
-static inline int zone_is_near_oom(struct zone *zone)
-{
-	return zone->pages_scanned >= (zone_lru_pages(zone) * 3);
-}
-
 /*
  * This moves pages from the active list to the inactive list.
  *
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
devices-cgroup-allow-mkfifo.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-inactive_anon_is_low-vmscan-style-cleanup.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-fix-calclation-of-active_ratio.patch
memcg-fix-calclation-of-active_ratio-build-error-fix.patch
memcg-show-real-limit-under-hierarchy-mode.patch
memcg-explain-details-and-test-document.patch
ia64-implement-interrupt-enabling-rwlocks-fix.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

