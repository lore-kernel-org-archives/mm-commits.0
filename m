From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 02 Mar 2010 10:49:21 -0800
Message-ID: <201003021849.o22InLH4023384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751997Ab0CBStj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 13:49:39 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id o22InMir017672
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 2 Mar 2010 10:49:23 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-mx25/clock.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/arm/mach-mx25/clock.c~linux-next-git-rejects arch/arm/mach-mx25/clock.c
--- a/arch/arm/mach-mx25/clock.c~linux-next-git-rejects
+++ a/arch/arm/mach-mx25/clock.c
@@ -239,12 +239,9 @@ int __init mx25_clocks_init(void)
 	__raw_writel((0xf << 16) | (3 << 26), CRM_BASE + CCM_CGCR1);
 	__raw_writel((1 << 5), CRM_BASE + CCM_CGCR2);
 
-<<<<<<< HEAD:arch/arm/mach-mx25/clock.c
-=======
 	/* Clock source for lcdc is upll */
 	__raw_writel(__raw_readl(CRM_BASE+0x64) | (1 << 7), CRM_BASE + 0x64);
 
->>>>>>> FETCH_HEAD:arch/arm/mach-mx25/clock.c
 	mxc_timer_init(&gpt_clk, MX25_IO_ADDRESS(MX25_GPT1_BASE_ADDR), 54);
 
 	return 0;
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
mqueue-apply-mathematics-distributivity-on-mq_bytes-calculation-checkpatch-fixes.patch
3x59x-fix-pci-resource-management.patch
kernel-schedc-suppress-unused-var-warning.patch
usb-serial-ftdi-add-contec-vendor-and-product-id-fix.patch
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
broadsheetfb-support-storing-waveform-fix.patch
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
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

