From: akpm@linux-foundation.org
Subject: [merged] bitops-remove-temporary-for_each_bit.patch removed from -mm tree
Date: Wed, 07 Apr 2010 11:49:21 -0400
Message-ID: <201004071850.o37IolIa001233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002Ab0DGSu6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 14:50:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, akinobu.mita@gmail.com, dwmw2@infradead.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     bitops: remove temporary for_each_bit()
has been removed from the -mm tree.  Its filename was
     bitops-remove-temporary-for_each_bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bitops: remove temporary for_each_bit()
From: Andrew Morton <akpm@linux-foundation.org>

Migration has been completed so remove this now.  There's one straggler in
linux-next's drivers/mtd/sm_ftl.c.  A patch has been sent.

Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/linux/bitops.h~bitops-remove-temporary-for_each_bit include/linux/bitops.h
--- a/include/linux/bitops.h~bitops-remove-temporary-for_each_bit
+++ a/include/linux/bitops.h
@@ -21,9 +21,6 @@
 	     (bit) < (size); \
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
 
-/* Temporary */
-#define for_each_bit(bit, addr, size) for_each_set_bit(bit, addr, size)
-
 static __inline__ int get_bitmask_order(unsigned int count)
 {
 	int order;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-crypto-aesni-intel_asms-still-busted.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
intel-agpc-fix-crash-when-accessing-nonexistent-gtt-entries-in-i915-checkpatch-fixes.patch
drivers-acpi-use-kasprintf-fix.patch
acpi_pad-processor_aggregator-name-too-long-fix.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cifs-provide-user-with-a-hint-when-name-resolution-fails-fix.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
gpio-add-support-for-janz-vmod-ttl-digital-io-module-fix.patch
ipc-mqueuec-let-message-queue-timeout-use-hrtimers-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-checkpatch-fixes.patch
serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed-fix.patch
kernel-irq-managec-add-raise_threaded_irq-fix.patch
max3100-to_max3100_port-small-style-fixes-fix.patch
iio-iio_get_new_idr_val-return-negative-value-on-failure-fix.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
firmware-loader-use-statically-initialized-data-attribute-fix.patch
firmware-loader-use-statically-initialized-data-attribute-fix-fix.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem.patch
gpiolib-make-names-array-and-its-values-const-fix.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch
x86_32-use-asm-generic-scatterlisth.patch
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

