From: akpm@linux-foundation.org
Subject: [folded] percpu_counter-change-return-value-and-add-comments-fix.patch removed from -mm tree
Date: Tue, 24 May 2011 17:06:40 -0700
Message-ID: <201105250006.p4P06eUn024470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754753Ab1EYAHJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 20:07:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, shaohua.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     percpu_counter-change-return-value-and-add-comments-fix
has been removed from the -mm tree.  Its filename was
     percpu_counter-change-return-value-and-add-comments-fix.patch

This patch was dropped because it was folded into percpu_counter-change-return-value-and-add-comments.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: percpu_counter-change-return-value-and-add-comments-fix
From: Andrew Morton <akpm@linux-foundation.org>

tweak comment

Cc: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu_counter.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/percpu_counter.h~percpu_counter-change-return-value-and-add-comments-fix include/linux/percpu_counter.h
--- a/include/linux/percpu_counter.h~percpu_counter-change-return-value-and-add-comments-fix
+++ a/include/linux/percpu_counter.h
@@ -134,8 +134,8 @@ static inline s64 percpu_counter_read(st
 }
 
 /*
- * percpu_counter is intended to track positive number. In UP case, the number
- * should never be negative.
+ * percpu_counter is intended to track positive numbers. In the UP case the
+ * number should never be negative.
  */
 static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
 {
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
nommu-add-page-alignment-to-mmap.patch
alpha-hook-up-gpiolib-support.patch
cris-convert-old-cpumask-api-into-new-one.patch
bitmap-irq-add-smp_affinity_list-interface-to-proc-irq.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure.patch
printk-allocate-kernel-log-buffer-earlier-v2.patch
drivers-leds-leds-lm3530c-add-regulator.patch
leds-provide-helper-to-register-leds-gpio-devices.patch
lru_cache-use-correct-type-in-sizeof-for-allocation.patch
percpu_counter-change-return-value-and-add-comments.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-gpio-vx855_gpioc-needs-slabh.patch
drivers-gpio-ml_ioh_gpioc-needs-slabh.patch
drivers-tty-serial-pch_uartc-needs-slabh.patch

