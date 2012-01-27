From: akpm@linux-foundation.org
Subject: + video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes.patch added to -mm tree
Date: Fri, 27 Jan 2012 14:13:38 -0800
Message-ID: <20120127221338.6B516A016E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:54720 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266Ab2A0WNl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jan 2012 17:13:41 -0500
Received: by eaaf1 with SMTP id f1so106003eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Jan 2012 14:13:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, FlorianSchandinat@gmx.de, dh09.lee@samsung.com, inki.dae@samsung.com, jg1.han@samsung.com, kyungmin.park@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes

Cc: Donghwa Lee <dh09.lee@samsung.com>

WARNING: please write a paragraph that describes the config symbol fully
#32: FILE: drivers/video/exynos/Kconfig:16:
 config EXYNOS_MIPI_DSI

WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt
+	msleep(1);
WARNING: struct backlight_ops should normally be const
#787: FILE: drivers/video/exynos/s6e8ax0.c:727:
+static struct backlight_ops s6e8ax0_backlight_ops = {

WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt
+	msleep(5);
total: 0 errors, 4 warnings, 941 lines checked

./patches/video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Donghwa Lee <dh09.lee@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/exynos/s6e8ax0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/exynos/s6e8ax0.c~video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes drivers/video/exynos/s6e8ax0.c
--- a/drivers/video/exynos/s6e8ax0.c~video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes
+++ a/drivers/video/exynos/s6e8ax0.c
@@ -724,7 +724,7 @@ static struct lcd_ops s6e8ax0_lcd_ops = 
 	.get_power = s6e8ax0_get_power,
 };
 
-static struct backlight_ops s6e8ax0_backlight_ops = {
+static const struct backlight_ops s6e8ax0_backlight_ops = {
 	.get_brightness = s6e8ax0_get_brightness,
 	.update_status = s6e8ax0_set_brightness,
 };
_
Subject: Subject: video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-memcontrolc-fix-warning-with-config_numa=n.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
fs-btrfs-inode-mapc-fix-warnings.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
hpet-factor-timer-allocate-from-open.patch
thermal-thermal_sys-fix-build-warning-fix.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-fix.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

