From: akpm@linux-foundation.org
Subject: [folded] bitmap-irq-add-smp_affinity_list-interface-to-proc-irq-fix.patch removed from -mm tree
Date: Tue, 24 May 2011 17:03:17 -0700
Message-ID: <201105250003.p4P03Iks024327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933302Ab1EYAEF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 20:04:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andy.shevchenko@gmail.com, lee.schermerhorn@hp.com, steiner@sgi.com, tglx@linutronix.de, travis@sgi.com, mm-commits@vger.kernel.org


The patch titled
     bitmap-irq-add-smp_affinity_list-interface-to-proc-irq-fix
has been removed from the -mm tree.  Its filename was
     bitmap-irq-add-smp_affinity_list-interface-to-proc-irq-fix.patch

This patch was dropped because it was folded into bitmap-irq-add-smp_affinity_list-interface-to-proc-irq.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bitmap-irq-add-smp_affinity_list-interface-to-proc-irq-fix
From: Andrew Morton <akpm@linux-foundation.org>

make __bitmap_parselist() static

Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/bitmap.c~bitmap-irq-add-smp_affinity_list-interface-to-proc-irq-fix lib/bitmap.c
--- a/lib/bitmap.c~bitmap-irq-add-smp_affinity_list-interface-to-proc-irq-fix
+++ a/lib/bitmap.c
@@ -590,7 +590,7 @@ EXPORT_SYMBOL(bitmap_scnlistprintf);
  *    %-EINVAL: invalid character in string
  *    %-ERANGE: bit number specified too large for mask
  */
-int __bitmap_parselist(const char *buf, unsigned int buflen,
+static int __bitmap_parselist(const char *buf, unsigned int buflen,
 		int is_user, unsigned long *maskp,
 		int nmaskbits)
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

