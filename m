From: akpm@linux-foundation.org
Subject: + davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch added to -mm tree
Date: Mon, 22 Mar 2010 12:43:42 -0700
Message-ID: <201003221943.o2MJhhAP023441__35445.8795780831$1269287071$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752727Ab0CVToN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 15:44:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, chaithrika@ti.com, khilman@deeprootsystems.com, linux-mmc@vger.kernel.org, sudhakar.raj@ti.com, vipin.bhandari@ti.com


The patch titled
     davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch

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
Subject: davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: struct dev_pm_ops should normally be const
#83: FILE: drivers/mmc/host/davinci_mmc.c:1379:
+static struct dev_pm_ops davinci_mmcsd_pm = {

total: 0 errors, 1 warnings, 81 lines checked

./patches/davinci-mmc-updates-to-suspend-resume-implementation.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: <linux-mmc@vger.kernel.org>
Cc: Chaithrika U S <chaithrika@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Cc: Vipin Bhandari <vipin.bhandari@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/davinci_mmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/davinci_mmc.c~davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes drivers/mmc/host/davinci_mmc.c
--- a/drivers/mmc/host/davinci_mmc.c~davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes
+++ a/drivers/mmc/host/davinci_mmc.c
@@ -1376,7 +1376,7 @@ static int davinci_mmcsd_resume(struct d
 	return ret;
 }
 
-static struct dev_pm_ops davinci_mmcsd_pm = {
+static const struct dev_pm_ops davinci_mmcsd_pm = {
 	.suspend        = davinci_mmcsd_suspend,
 	.resume         = davinci_mmcsd_resume,
 };
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-i2c-busses-i2c-xiicc-is-borked.patch
rtc-davinci-rtc-driver-checkpatch-fixes.patch
c2port-fix-device_create-return-value-check-fix.patch
drivers-acpi-use-kasprintf-fix.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
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

