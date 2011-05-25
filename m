From: akpm@linux-foundation.org
Subject: [folded] alpha-hook-up-gpiolib-support-fix.patch removed from -mm tree
Date: Tue, 24 May 2011 17:00:50 -0700
Message-ID: <201105250000.p4P00o96024183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932838Ab1EYABE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 20:01:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha-hook-up-gpiolib-support-fix
has been removed from the -mm tree.  Its filename was
     alpha-hook-up-gpiolib-support-fix.patch

This patch was dropped because it was folded into alpha-hook-up-gpiolib-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha-hook-up-gpiolib-support-fix
From: Andrew Morton <akpm@linux-foundation.org>

define GENERIC_GPIO

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 alpha/include/asm/gpio.h |    0 
 arch/alpha/Kconfig       |    3 +++
 2 files changed, 3 insertions(+)

diff -puN arch/alpha/Kconfig~alpha-hook-up-gpiolib-support-fix arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~alpha-hook-up-gpiolib-support-fix
+++ a/arch/alpha/Kconfig
@@ -52,6 +52,9 @@ config GENERIC_CALIBRATE_DELAY
 config GENERIC_CMOS_UPDATE
         def_bool y
 
+config GENERIC_GPIO
+	def_bool y
+
 config ZONE_DMA
 	bool
 	default y
diff -puN arch/alpha/include/asm/gpio.h~alpha-hook-up-gpiolib-support-fix arch/alpha/include/asm/gpio.h
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

