From: akpm@linux-foundation.org
Subject: + hwmon-driver-for-ti-tmp102-temperature-sensor-checkpatch-fixes.patch added to -mm tree
Date: Thu, 04 Feb 2010 10:22:14 -0800
Message-ID: <201002041822.o14IMEG6013737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757313Ab0BDSWo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2010 13:22:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hjk@linutronix.de, khali@linux-fr.org, sfking@fdwdc.com, w.sang@pengutronix.de


The patch titled
     hwmon-driver-for-ti-tmp102-temperature-sensor-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     hwmon-driver-for-ti-tmp102-temperature-sensor-checkpatch-fixes.patch

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
Subject: hwmon-driver-for-ti-tmp102-temperature-sensor-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: struct dev_pm_ops should normally be const
#387: FILE: drivers/hwmon/tmp102.c:300:
+static struct dev_pm_ops tmp102_dev_pm_ops = {

total: 0 errors, 1 warnings, 395 lines checked

./patches/hwmon-driver-for-ti-tmp102-temperature-sensor.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Hans J. Koch <hjk@linutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Steven King <sfking@fdwdc.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/tmp102.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hwmon/tmp102.c~hwmon-driver-for-ti-tmp102-temperature-sensor-checkpatch-fixes drivers/hwmon/tmp102.c
--- a/drivers/hwmon/tmp102.c~hwmon-driver-for-ti-tmp102-temperature-sensor-checkpatch-fixes
+++ a/drivers/hwmon/tmp102.c
@@ -297,7 +297,7 @@ static int tmp102_resume(struct device *
 	return 0;
 }
 
-static struct dev_pm_ops tmp102_dev_pm_ops = {
+static const struct dev_pm_ops tmp102_dev_pm_ops = {
 	.suspend	= tmp102_suspend,
 	.resume		= tmp102_resume,
 };
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix-fix-2.patch
pci-update-pci_set_vga_state-to-call-arch-functions.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
kernel-schedc-suppress-unused-var-warning.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
add-generic-sys_ipc-wrapper-fix.patch
lib-more-scalable-list_sort-fix.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
kmod-add-init-function-to-usermodehelper-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

