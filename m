From: akpm@linux-foundation.org
Subject: [obsolete] drivers-i2c-busses-i2c-xiicc-is-borked.patch removed from -mm tree
Date: Mon, 29 Mar 2010 11:36:54 -0400
Message-ID: <201003291838.o2TIc1Va030821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750957Ab0C2Sio (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Mar 2010 14:38:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     drivers/i2c/busses/i2c-xiic.c is borked
has been removed from the -mm tree.  Its filename was
     drivers-i2c-busses-i2c-xiicc-is-borked.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/i2c/busses/i2c-xiic.c is borked
From: Andrew Morton <akpm@linux-foundation.org>

Someone forgot to add i2c-xiic.h

Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-xiic.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/i2c/busses/i2c-xiic.c~drivers-i2c-busses-i2c-xiicc-is-borked drivers/i2c/busses/i2c-xiic.c
--- a/drivers/i2c/busses/i2c-xiic.c~drivers-i2c-busses-i2c-xiicc-is-borked
+++ a/drivers/i2c/busses/i2c-xiic.c
@@ -37,7 +37,7 @@
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
 #include <linux/wait.h>
-#include <linux/i2c-xiic.h>
+//#include <linux/i2c-xiic.h>
 #include <linux/io.h>
 
 #define DRIVER_NAME "xiic-i2c"
@@ -748,8 +748,8 @@ static int __devinit xiic_i2c_probe(stru
 	}
 
 	/* add in known devices to the bus */
-	for (i = 0; i < pdata->num_devices; i++)
-		i2c_new_device(&i2c->adap, pdata->devices + i);
+//	for (i = 0; i < pdata->num_devices; i++)
+//		i2c_new_device(&i2c->adap, pdata->devices + i);
 
 	return 0;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-crypto-aesni-intel_asms-still-busted.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-i2c-busses-i2c-xiicc-is-borked.patch
ratelimit-annotate-___ratelimit-fix.patch
rtc-mxc-multiple-fixes-in-rtc-mxc-probe-method-checkpatch-fixes.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
drivers-acpi-use-kasprintf-fix.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed-fix.patch
kernel-irq-managec-add-raise_threaded_irq-fix.patch
max3100-to_max3100_port-small-style-fixes-fix.patch
serial-add-driver-for-the-altera-uart-unbork.patch
iio-iio_get_new_idr_val-return-negative-value-on-failure-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
firmware-loader-use-statically-initialized-data-attribute-fix.patch
firmware-loader-use-statically-initialized-data-attribute-fix-fix.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch
bitops-remove-temporary-for_each_bit.patch
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

