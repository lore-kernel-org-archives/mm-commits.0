From: akpm@linux-foundation.org
Subject: [folded] mm-filter-unevictable-page-out-in-deactivate_page-fix-fix.patch removed from -mm tree
Date: Tue, 24 May 2011 16:59:53 -0700
Message-ID: <201105242359.p4ONxrP1024102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932674Ab1EXX77 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 19:59:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm-filter-unevictable-page-out-in-deactivate_page-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-filter-unevictable-page-out-in-deactivate_page-fix-fix.patch

This patch was dropped because it was folded into mm-filter-unevictable-page-out-in-deactivate_page.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-filter-unevictable-page-out-in-deactivate_page-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

bah

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel<riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/swap.c~mm-filter-unevictable-page-out-in-deactivate_page-fix-fix mm/swap.c
--- a/mm/swap.c~mm-filter-unevictable-page-out-in-deactivate_page-fix-fix
+++ a/mm/swap.c
@@ -477,8 +477,8 @@ static void drain_cpu_pagevecs(int cpu)
 void deactivate_page(struct page *page)
 {
 	/*
-	 * In a workload which with many unevictable page such as mprotect,
-	 * unevictable page deactivation for accelerating reclaim is pointless.
+	 * In a workload with many unevictable page such as mprotect, unevictable
+	 * page deactivation for accelerating reclaim is pointless.
 	 */
 	if (PageUnevictable(page))
 		return;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value.patch
mm-nommu-sort-mm-mmap-list-properly.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch
mm-mmu_gather-rework.patch
mm-uninline-large-generic-tlbh-functions.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
mm-filter-unevictable-page-out-in-deactivate_page.patch
nommu-add-page-alignment-to-mmap-checkpatch-fixes.patch
alpha-hook-up-gpiolib-support-fix.patch
cris-convert-old-cpumask-api-into-new-one-checkpatch-fixes.patch
bitmap-irq-add-smp_affinity_list-interface-to-proc-irq-fix.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch
printk-allocate-kernel-log-buffer-earlier-v2-checkpatch-fixes.patch
printk-allocate-kernel-log-buffer-earlier-v2-fix.patch
drivers-leds-leds-lm3530c-add-regulator-checkpatch-fixes.patch
leds-provide-helper-to-register-leds-gpio-devices.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
percpu_counter-change-return-value-and-add-comments-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-gpio-vx855_gpioc-needs-slabh.patch
drivers-gpio-ml_ioh_gpioc-needs-slabh.patch
drivers-tty-serial-pch_uartc-needs-slabh.patch

