From: akpm@linux-foundation.org
Subject: [folded] led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 27 Apr 2010 11:34:53 -0700
Message-ID: <201004271902.o3RJ2I1w013823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754520Ab0D0TDI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Apr 2010 15:03:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, gurligebis@gentoo.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     led-driver-for-the-soekris-net5501-board-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch

This patch was dropped because it was folded into led-driver-for-the-soekris-net5501-board.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: led-driver-for-the-soekris-net5501-board-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: that open brace { should be on the previous line
#120: FILE: drivers/leds/leds-net5501.c:67:
+	if (!rombase)
+	{

total: 1 errors, 0 warnings, 117 lines checked

./patches/led-driver-for-the-soekris-net5501-board.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-net5501.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/leds/leds-net5501.c~led-driver-for-the-soekris-net5501-board-checkpatch-fixes drivers/leds/leds-net5501.c
--- a/drivers/leds/leds-net5501.c~led-driver-for-the-soekris-net5501-board-checkpatch-fixes
+++ a/drivers/leds/leds-net5501.c
@@ -64,8 +64,7 @@ static int __init soekris_init(void)
 		return 0;
 
 	rombase = ioremap(0xffff0000, 0xffff);
-	if (!rombase)
-	{
+	if (!rombase) {
 		printk(KERN_INFO "Soekris net5501 LED driver failed to get rombase");
 		return 0;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
fix-pca953x-set_type-scheduling-while-atomic-bug-checkpatch-fixes.patch
drivers-acpi-use-kasprintf.patch
acpi_pad-processor_aggregator-name-too-long.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
jfs-free-sbi-memory-in-error-path.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks.patch
hpet-factor-timer-allocate-from-open.patch
led-driver-for-the-soekris-net5501-board.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
gpio-add-support-for-janz-vmod-ttl-digital-io-module-fix.patch
3x59x-fix-pci-resource-management.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-checkpatch-fixes.patch
serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed-fix.patch
kernel-irq-managec-add-raise_threaded_irq-fix.patch
max3100-to_max3100_port-small-style-fixes-fix.patch
drivers-scsi-scsi_sysfsc-fix-sdev_rw_attr-macro-for-scsi-device-sysfs-entries-checkpatch-fixes.patch
laptop-mode-make-flushes-per-device-fix.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-export-unusable-free-space-index-via-debugfs.patch
mmcompaction-direct-compact-when-a-high-order-allocation-fails.patch
buffer_head-remove-redundant-test-from-wait_on_buffer-fix.patch
wait_on_buffer-remove-the-buffer_locked-test.patch
mm-introduce-free_pages_prepare-fix.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min-fix.patch
dynamic_debug-fix-documentation-errors-checkpatch-fixes.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch
crc32-major-optimization-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
hwmon-add-ti-ads7871-a-d-converter-driver-checkpatch-fixes.patch
rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem.patch
gpiolib-make-names-array-and-its-values-const-fix.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
memcg-move-charge-of-file-pages-fix.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
drivers-edac-convert-logging-messages-direct-uses-of-__file__-to-%s-__file-checkpatch-fixes.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch
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
notify_change-callers-must-hold-i_mutex.patch

