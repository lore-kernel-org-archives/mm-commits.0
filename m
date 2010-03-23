From: akpm@linux-foundation.org
Subject: [obsolete] rtc-davinci-rtc-driver-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 23 Mar 2010 12:14:19 -0700
Message-ID: <201003231914.o2NJEJ0h020618@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753080Ab0CWTO6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 15:14:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, miguel.aguilar@ridgerun.com, mm-commits@vger.kernel.org


The patch titled
     rtc-davinci-rtc-driver-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     rtc-davinci-rtc-driver-checkpatch-fixes.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-davinci-rtc-driver-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: please, no space before tabs
#180: FILE: drivers/rtc/rtc-davinci.c:119:
+^Istruct rtc_device ^I^I*rtc;$

total: 0 errors, 1 warnings, 696 lines checked

./patches/rtc-davinci-rtc-driver.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Miguel Aguilar <miguel.aguilar@ridgerun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-davinci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-davinci.c~rtc-davinci-rtc-driver-checkpatch-fixes drivers/rtc/rtc-davinci.c
--- a/drivers/rtc/rtc-davinci.c~rtc-davinci-rtc-driver-checkpatch-fixes
+++ a/drivers/rtc/rtc-davinci.c
@@ -116,7 +116,7 @@
 static DEFINE_SPINLOCK(davinci_rtc_lock);
 
 struct davinci_rtc {
-	struct rtc_device 		*rtc;
+	struct rtc_device		*rtc;
 	void __iomem			*base;
 	resource_size_t			pbase;
 	size_t				base_size;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

rtc-davinci-rtc-driver-checkpatch-fixes.patch
c2port-fix-device_create-return-value-check-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-i2c-busses-i2c-xiicc-is-borked.patch
ratelimit-annotate-___ratelimit-fix.patch
drivers-acpi-use-kasprintf-fix.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
hpet-factor-timer-allocate-from-open-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
iio-iio_get_new_idr_val-return-negative-value-on-failure-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
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

