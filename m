From: akpm@linux-foundation.org
Subject: [to-be-updated] drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch removed from -mm tree
Date: Tue, 10 May 2011 15:17:34 -0700
Message-ID: <201105102217.p4AMHYuK025523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090Ab1EJWSY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 May 2011 18:18:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, aghayal@codeaurora.org, lars@metafoo.de, mcuos.com@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix
has been removed from the -mm tree.  Its filename was
     drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix
From: Andrew Morton <akpm@linux-foundation.org>

tiny cleanups

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Anirudh Ghayal <aghayal@codeaurora.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pm8xxx.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-pm8xxx.c~drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix drivers/rtc/rtc-pm8xxx.c
--- a/drivers/rtc/rtc-pm8xxx.c~drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix
+++ a/drivers/rtc/rtc-pm8xxx.c
@@ -15,7 +15,7 @@
 #include <linux/rtc.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
-#include<linux/spinlock.h>
+#include <linux/spinlock.h>
 
 #include <linux/mfd/pm8xxx/core.h>
 #include <linux/mfd/pm8xxx/rtc.h>
@@ -207,8 +207,7 @@ pm8xxx_rtc_read_time(struct device *dev,
 		}
 	}
 
-	secs = value[0] | (value[1] << 8) | (value[2] << 16) \
-						| (value[3] << 24);
+	secs = value[0] | (value[1] << 8) | (value[2] << 16) | (value[3] << 24);
 
 	rtc_time_to_tm(secs, tm);
 
@@ -302,8 +301,7 @@ pm8xxx_rtc_read_alarm(struct device *dev
 		return rc;
 	}
 
-	secs = value[0] | (value[1] << 8) | (value[2] << 16) | \
-						 (value[3] << 24);
+	secs = value[0] | (value[1] << 8) | (value[2] << 16) | (value[3] << 24);
 
 	rtc_time_to_tm(secs, &alarm->time);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-use-alloc_bootmem_node_nopanic-on-really-needed-path-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-i2c-busses-i2c-designware-corec-needs-delayh.patch
mm-add-alloc_pages_exact_nid-checkpatch-fixes.patch
mm-add-alloc_pages_exact_nid-fix.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-provide-helper-to-register-leds-gpio-devices-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
osst-wrong-index-used-in-inner-loop-checkpatch-fixes.patch
drivers-scsi-osstc-fix-warning.patch
drbd-fix-warning.patch
drivers-usb-misc-usbtestc-fix-warning.patch
slab-use-numa_no_node.patch
mm.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.patch
mm-mmu_gather-rework-fix.patch
mm-uninline-large-generic-tlbh-functions.patch
mm-thp-optimize-memcg-charge-in-khugepaged-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-checkpatch-fixes.patch
writeback-sync-expired-inodes-first-in-background-writeback-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
nommu-add-page-alignment-to-mmap-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
cris-convert-old-cpumask-api-into-new-one-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch
printk-allocate-kernel-log-buffer-earlier-v2-checkpatch-fixes.patch
printk-allocate-kernel-log-buffer-earlier-v2-fix.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
percpu_counter-change-return-value-and-add-comments-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-add-stats-to-monitor-soft_limit-reclaim-v2-fix.patch
memcg-add-stats-to-monitor-soft_limit-reclaim-v2-fix-2.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

