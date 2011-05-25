From: akpm@linux-foundation.org
Subject: [folded] drivers-leds-leds-lm3530c-add-regulator-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 24 May 2011 17:05:23 -0700
Message-ID: <201105250005.p4P05NBC024433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932912Ab1EYAF5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 20:05:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, shreshthakumar.sahu@stericsson.com, mm-commits@vger.kernel.org


The patch titled
     drivers-leds-leds-lm3530c-add-regulator-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-lm3530c-add-regulator-checkpatch-fixes.patch

This patch was dropped because it was folded into drivers-leds-leds-lm3530c-add-regulator.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers-leds-leds-lm3530c-add-regulator-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: trailing whitespace
#68: FILE: drivers/leds/leds-lm3530.c:212:
+^I$

total: 1 errors, 0 warnings, 141 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/drivers-leds-leds-lm3530c-add-regulator.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lm3530.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-lm3530.c~drivers-leds-leds-lm3530c-add-regulator-checkpatch-fixes drivers/leds/leds-lm3530.c
--- a/drivers/leds/leds-lm3530.c~drivers-leds-leds-lm3530c-add-regulator-checkpatch-fixes
+++ a/drivers/leds/leds-lm3530.c
@@ -209,7 +209,7 @@ static int lm3530_init_registers(struct 
 		}
 		drvdata->enable = true;
 	}
-	
+
 	for (i = 0; i < LM3530_REG_MAX; i++) {
 		ret = i2c_smbus_write_byte_data(client,
 				lm3530_reg[i], reg_val[i]);
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
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
percpu_counter-change-return-value-and-add-comments-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-gpio-vx855_gpioc-needs-slabh.patch
drivers-gpio-ml_ioh_gpioc-needs-slabh.patch
drivers-tty-serial-pch_uartc-needs-slabh.patch

