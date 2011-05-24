From: akpm@linux-foundation.org
Subject: [folded] mm-mmu_gather-rework-fix.patch removed from -mm tree
Date: Tue, 24 May 2011 16:54:03 -0700
Message-ID: <201105242354.p4ONs3KL023779@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933261Ab1EXXyL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 19:54:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     mm-mmu_gather-rework-fix
has been removed from the -mm tree.  Its filename was
     mm-mmu_gather-rework-fix.patch

This patch was dropped because it was folded into mm-mmu_gather-rework.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-mmu_gather-rework-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix comment tpyo

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/tlb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/tlb.h~mm-mmu_gather-rework-fix include/asm-generic/tlb.h
--- a/include/asm-generic/tlb.h~mm-mmu_gather-rework-fix
+++ a/include/asm-generic/tlb.h
@@ -30,7 +30,7 @@
 #endif
 
 /*
- * If we can't allocate a page to make a big patch of page pointers
+ * If we can't allocate a page to make a big batch of page pointers
  * to work on, then just handle a few from the on-stack structure.
  */
 #define MMU_GATHER_BUNDLE	8
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value.patch
mm-nommu-sort-mm-mmap-list-properly.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch
mm-mmu_gather-rework.patch
mm-uninline-large-generic-tlbh-functions.patch
mm-thp-optimize-memcg-charge-in-khugepaged-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-checkpatch-fixes.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix-fix.patch
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

