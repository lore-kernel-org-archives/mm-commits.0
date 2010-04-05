From: akpm@linux-foundation.org
Subject: + gpio-add-support-for-janz-vmod-ttl-digital-io-module-fix.patch added to -mm tree
Date: Mon, 05 Apr 2010 15:06:46 -0700
Message-ID: <201004052233.o35MXfAT013095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756439Ab0DEWeU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 18:34:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, david-b@pacbell.net, iws@ovro.caltech.edu, sameo@linux.intel.com


The patch titled
     gpio-add-support-for-janz-vmod-ttl-digital-io-module-fix
has been added to the -mm tree.  Its filename is
     gpio-add-support-for-janz-vmod-ttl-digital-io-module-fix.patch

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
Subject: gpio-add-support-for-janz-vmod-ttl-digital-io-module-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix build

Cc: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: David Brownell <david-b@pacbell.net>
Cc: Ira W. Snyder <iws@ovro.caltech.edu>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/janz-ttl.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/gpio/janz-ttl.c~gpio-add-support-for-janz-vmod-ttl-digital-io-module-fix drivers/gpio/janz-ttl.c
--- a/drivers/gpio/janz-ttl.c~gpio-add-support-for-janz-vmod-ttl-digital-io-module-fix
+++ a/drivers/gpio/janz-ttl.c
@@ -11,6 +11,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bitops-remove-temporary-for_each_bit.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-crypto-aesni-intel_asms-still-busted.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
exit-fix-oops-in-sync_mm_rss-fix.patch
drivers-char-amiserialc-add-missing-local_irq_restore.patch
mxser-spin_lock-=-spin_lock_irq-fix.patch
ratelimit-annotate-___ratelimit-fix.patch
rtc-mxc-multiple-fixes-in-rtc-mxc-probe-method-checkpatch-fixes.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
intel-agpc-fix-crash-when-accessing-nonexistent-gtt-entries-in-i915-checkpatch-fixes.patch
drivers-acpi-use-kasprintf-fix.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cifs-provide-user-with-a-hint-when-name-resolution-fails-fix.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
gpio-add-support-for-janz-vmod-ttl-digital-io-module-fix.patch
ipc-mqueuec-let-message-queue-timeout-use-hrtimers-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-checkpatch-fixes.patch
serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed-fix.patch
kernel-irq-managec-add-raise_threaded_irq-fix.patch
max3100-to_max3100_port-small-style-fixes-fix.patch
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

