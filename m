From: akpm@linux-foundation.org
Subject: + x86-platform-driver-intelligent-power-sharing-driver-checkpatch-fixes.patch added to -mm tree
Date: Fri, 14 May 2010 16:12:44 -0700
Message-ID: <201005142312.o4ENCi8w028170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752593Ab0ENXMr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 May 2010 19:12:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jbarnes@virtuousgeek.org


The patch titled
     x86-platform-driver-intelligent-power-sharing-driver-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     x86-platform-driver-intelligent-power-sharing-driver-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86-platform-driver-intelligent-power-sharing-driver-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: please, no space before tabs
#277: FILE: drivers/platform/x86/intel_ips.c:214:
+#define   STS_PP_SHIFT  ^I10$

WARNING: please, no space before tabs
#284: FILE: drivers/platform/x86/intel_ips.c:221:
+#define   STS_PTL_MASK  ^I(0x000000fe)$

WARNING: please, no space before tabs
#285: FILE: drivers/platform/x86/intel_ips.c:222:
+#define   STS_PTL_SHIFT ^I1$

WARNING: line over 80 characters
#362: FILE: drivers/platform/x86/intel_ips.c:299:
+	/* Average CPU core temps (all averages in .01 degrees C for precision) */

WARNING: line over 80 characters
#830: FILE: drivers/platform/x86/intel_ips.c:767:
+		schedule_timeout_interruptible(msecs_to_jiffies(IPS_ADJUST_PERIOD));

WARNING: line over 80 characters
#1037: FILE: drivers/platform/x86/intel_ips.c:974:
+		schedule_timeout_interruptible(msecs_to_jiffies(IPS_SAMPLE_PERIOD));

WARNING: line over 80 characters
#1115: FILE: drivers/platform/x86/intel_ips.c:1052:
+			dev_warn(&ips->dev->dev, "ME failed to update for more than 1s, likely hung\n");

WARNING: line over 80 characters
#1411: FILE: drivers/platform/x86/intel_ips.c:1348:
+		dev_warn(&ips->dev->dev, "Warning: CPU TDP doesn't match expected value (found %d, expected %d)\n",

WARNING: line over 80 characters
#1521: FILE: drivers/platform/x86/intel_ips.c:1458:
+		dev_err(&dev->dev, "thermal device not enabled (0x%02x), aborting\n", tse);

WARNING: line over 80 characters
#1529: FILE: drivers/platform/x86/intel_ips.c:1466:
+		dev_err(&dev->dev, "thermal reporting for required devices not enabled, aborting\n");

WARNING: line over 80 characters
#1538: FILE: drivers/platform/x86/intel_ips.c:1475:
+		dev_err(&dev->dev, "failed to get i915 symbols, graphics turbo disabled\n");

WARNING: line over 80 characters
#1560: FILE: drivers/platform/x86/intel_ips.c:1497:
+		dev_err(&dev->dev, "platform indicates TDP override unavailable, aborting\n");

total: 0 errors, 12 warnings, 1688 lines checked

./patches/x86-platform-driver-intelligent-power-sharing-driver.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/intel_ips.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/platform/x86/intel_ips.c~x86-platform-driver-intelligent-power-sharing-driver-checkpatch-fixes drivers/platform/x86/intel_ips.c
--- a/drivers/platform/x86/intel_ips.c~x86-platform-driver-intelligent-power-sharing-driver-checkpatch-fixes
+++ a/drivers/platform/x86/intel_ips.c
@@ -211,15 +211,15 @@
 #define   STS_GPL_MASK		(0x001ff000)
 #define   STS_GPL_SHIFT		12
 #define   STS_PP_MASK		(0x00000c00)
-#define   STS_PP_SHIFT  	10
+#define   STS_PP_SHIFT		10
 #define   STS_PP_DEF		0
 #define   STS_PP_PROC		1
 #define   STS_PP_BAL		2
 #define   STS_PP_GFX		3
 #define   STS_PCTD_DIS		(1<<9)
 #define   STS_GTD_DIS		(1<<8)
-#define   STS_PTL_MASK  	(0x000000fe)
-#define   STS_PTL_SHIFT 	1
+#define   STS_PTL_MASK		(0x000000fe)
+#define   STS_PTL_SHIFT		1
 #define   STS_NVV		(1<<0)
 #define THM_SEC		0x9c
 #define   SEC_ACK	(1<<0)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmc-at91_mci-modify-cache-flush-routines-fix.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
drivers-pci-intel-iommuc-errors-with-smaller-iommu-widths-fix.patch
x86-platform-driver-intelligent-power-sharing-driver-checkpatch-fixes.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
jfs-free-sbi-memory-in-error-path.patch
fix-drm-radeon-kms-hdmi-irq-support.patch
dib3000mc-reduce-large-stack-usage-fix.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks.patch
hpet-factor-timer-allocate-from-open.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
3x59x-fix-pci-resource-management.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-checkpatch-fixes.patch
kernel-mutexc-fix-unused-var-warning.patch
fix-stop_machine-reimplement-using-cpu_stop.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible-fix.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible-fix-2.patch
cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems-fix.patch
cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems-spelling.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-export-unusable-free-space-index-via-debugfs.patch
mmcompaction-direct-compact-when-a-high-order-allocation-fails.patch
buffer_head-remove-redundant-test-from-wait_on_buffer-fix.patch
wait_on_buffer-remove-the-buffer_locked-test.patch
mm-introduce-free_pages_prepare-fix.patch
cpu-mem-hotplug-enable-cpus-online-before-local-memory-online-fix.patch
cpu-mem-hotplug-enable-cpus-online-before-local-memory-online-checkpatch-fixes.patch
highmem-remove-unneeded-ifdef-config_trace_irqflags_support-for-debug_kmap_atomic.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min-fix.patch
kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min-fix-fix.patch
include-asm-generic-kmap_typesh-remove-km_sync_icache-and-km_sync_dcache.patch
include-asm-generic-kmap_typesh-add-helpful-reminder.patch
dynamic_debug-fix-documentation-errors-checkpatch-fixes.patch
lib-introduce-common-method-to-convert-hex-digits-fix.patch
lib-introduce-common-method-to-convert-hex-digits-fix-fix.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch
crc32-major-optimization-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
hwmon-add-ti-ads7871-a-d-converter-driver-checkpatch-fixes.patch
rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem.patch
gpiolib-make-names-array-and-its-values-const-fix.patch
s3c-fb-add-s5pv210-support-and-some-features-checkpatch-fixes.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
memcg-move-charge-of-file-pages-fix.patch
memcg-move-charge-of-file-pages-fix-4.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
ipc-semc-optimize-update_queue-for-bulk-wakeup-calls-fix.patch
ipc-semc-move-wake_up_process-out-of-the-spinlock-section-fix.patch
ipc-semc-move-wake_up_process-out-of-the-spinlock-section-fix-2.patch
ipmi-update-driver-to-use-dev_printk-and-its-constructs-checkpatch-fixes.patch
pids-increase-pid_max-based-on-num_possible_cpus-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
drivers-edac-convert-logging-messages-direct-uses-of-__file__-to-%s-__file-checkpatch-fixes.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch
aio-fix-the-compat-vectored-operations-checkpatch-fixes.patch
aio-fix-the-compat-vectored-operations-fix.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
kfifo-samples-dont-compile.patch
x86_32-use-asm-generic-scatterlisth.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch

