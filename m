From: akpm@linux-foundation.org
Subject: - memcg-fix-swap-accounting-leak-doc-fix.patch removed from -mm tree
Date: Wed, 07 Jan 2009 15:18:23 -0800
Message-ID: <200901072318.n07NIOPL002608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755199AbZAGXTI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 18:19:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg fix swap accounting leak doc fix
has been removed from the -mm tree.  Its filename was
     memcg-fix-swap-accounting-leak-doc-fix.patch

This patch was dropped because it was folded into memcg-fix-swap-accounting-leak-v3.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg fix swap accounting leak doc fix
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

fix for documentation.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com> 
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/controllers/memcg_test.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/controllers/memcg_test.txt~memcg-fix-swap-accounting-leak-doc-fix Documentation/controllers/memcg_test.txt
--- a/Documentation/controllers/memcg_test.txt~memcg-fix-swap-accounting-leak-doc-fix
+++ a/Documentation/controllers/memcg_test.txt
@@ -139,10 +139,10 @@ Under below explanation, we assume CONFI
           ===========================================
           (3)        +1/+1    +1/+1     +1/+1   +1/+1
           (4)          -       0/ 0       -     -1/ 0
-          (5)         0/ 1     0/-1     -1/-1    0/ 0
-          (6)          -        -         -      0/-1
+          (5)         0/-1     0/ 0     -1/-1    0/ 0
+          (6)          -       0/-1       -      0/-1
           ===========================================
-       Result         1/ 1     1/1       1/ 1    1/ 1
+       Result         1/ 1     1/ 1      1/ 1    1/ 1
 
        In any cases, charges to this page should be 1/ 1.
 
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

cgroups-make-cgroup-config-a-submenu.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-fix-gfp_mask-of-callers-of-charge.patch
memcg-simple-migration-handling.patch
memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup.patch
memcg-move-all-acccounts-to-parent-at-rmdir.patch
memcg-handle-swap-caches.patch
memcg-memswap-controller-kconfig.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memcg-avoid-unnecessary-system-wide-oom-killer.patch
memcg-fix-reclaim-result-checks.patch
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
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch
memcg-dont-trigger-oom-at-page-migration.patch
memcg-remove-mem_cgroup_try_charge.patch
memcg-avoid-dead-lock-caused-by-race-between-oom-and-cpuset_attach.patch
memcg-change-try_to_free_pages-to-hierarchical_reclaim.patch
memcg-fix-swap-accounting-leak-v3.patch
memcg-fix-swap-accounting-leak-doc-fix.patch
memcg-fix-double-free-and-make-refcnt-sane.patch
memcg-use-css_tryget-in-memcg.patch
memcg-use-css_tryget-in-memcg-fix.patch
memcg-fix-lru-accounting-for-swapcache-v2.patch
memcg-fix-shmems-swap-accounting.patch

