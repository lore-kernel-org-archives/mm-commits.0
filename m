From: akpm@linux-foundation.org
Subject: [to-be-updated] mx3fb-introduce-waveform-configuration-for-pixel-clock-signal-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 03 Mar 2010 14:13:31 -0800
Message-ID: <201003032213.o23MDVxb001907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756854Ab0CCWNj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Mar 2010 17:13:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, maramaopercheseimorto@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mx3fb-introduce-waveform-configuration-for-pixel-clock-signal-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mx3fb-introduce-waveform-configuration-for-pixel-clock-signal-checkpatch-fixes.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mx3fb-introduce-waveform-configuration-for-pixel-clock-signal-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#116: FILE: drivers/video/mx3fb.c:532:
+^I^I              mx3fb_pdata->pix_clk_width)) / 16) >> 2) << 22;$

total: 1 errors, 0 warnings, 94 lines checked

./patches/mx3fb-introduce-waveform-configuration-for-pixel-clock-signal.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mx3fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/mx3fb.c~mx3fb-introduce-waveform-configuration-for-pixel-clock-signal-checkpatch-fixes drivers/video/mx3fb.c
--- a/drivers/video/mx3fb.c~mx3fb-introduce-waveform-configuration-for-pixel-clock-signal-checkpatch-fixes
+++ a/drivers/video/mx3fb.c
@@ -529,7 +529,7 @@ static int sdc_init_panel(struct mx3fb_d
 	old_conf = div;
 	old_conf |= (((div * mx3fb_pdata->pix_clk_start) / 16) >> 2) << 12;
 	old_conf |= (((div * (mx3fb_pdata->pix_clk_start +
-		              mx3fb_pdata->pix_clk_width)) / 16) >> 2) << 22;
+			      mx3fb_pdata->pix_clk_width)) / 16) >> 2) << 22;
 
 	mx3fb_write_reg(mx3fb, old_conf , DI_DISP3_TIME_CONF);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-arm.patch
bitops-rename-for_each_bit-to-for_each_set_bit-net.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
mqueue-apply-mathematics-distributivity-on-mq_bytes-calculation-checkpatch-fixes.patch
3x59x-fix-pci-resource-management.patch
kernel-schedc-suppress-unused-var-warning.patch
usb-serial-ftdi-add-contec-vendor-and-product-id-fix.patch
drivers-watchdog-wdtc-wdt_ioctl-make-ident-non-static.patch
drivers-char-tty_bufferc-fix-min-warnings.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
add-generic-sys_ipc-wrapper-fix.patch
lib-more-scalable-list_sort-fix.patch
fs-compat_ioctlc-suppress-two-warnings.patch
sdio-introduce-api-for-special-power-management-features-fix.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes.patch
gpio-pca953xc-add-interrupt-handling-capability.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
gpio-cs5535-gpio-fix-input-direction.patch
broadsheetfb-support-storing-waveform-fix.patch
mx3fb-introduce-waveform-configuration-for-pixel-clock-signal-checkpatch-fixes.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
drivers-char-memc-cleanups-fix-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
kmod-add-init-function-to-usermodehelper-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
pps-linuxpps-clients-support-v3-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

