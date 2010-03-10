From: akpm@linux-foundation.org
Subject: [folded] sysctl-extern-cleanup-binfmts-fix.patch removed from -mm tree
Date: Wed, 10 Mar 2010 15:06:53 -0800
Message-ID: <201003102306.o2AN6rXf009369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932801Ab0CJXHO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 18:07:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, adobriyan@gmail.com, ebiederm@xmission.com, hidave.darkstar@gmail.com, jmorris@namei.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     sysctl-extern-cleanup-binfmts-fix
has been removed from the -mm tree.  Its filename was
     sysctl-extern-cleanup-binfmts-fix.patch

This patch was dropped because it was folded into sysctl-extern-cleanup-binfmts.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl-extern-cleanup-binfmts-fix
From: Andrew Morton <akpm@linux-foundation.org>

not sure how that happened..

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: James Morris <jmorris@namei.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/binfmts.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/binfmts.h~sysctl-extern-cleanup-binfmts-fix include/linux/binfmts.h
--- a/include/linux/binfmts.h~sysctl-extern-cleanup-binfmts-fix
+++ a/include/linux/binfmts.h
@@ -22,7 +22,7 @@ struct pt_regs;
 
 /* for sysctl */
 extern int core_uses_pid;
-extern char *core_pattern;
+extern char core_pattern[];
 extern unsigned int core_pipe_limit;
 
 #define CORENAME_MAX_SIZE 128
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

add-generic-sys_ipc-wrapper.patch
broadsheetfb-support-storing-waveform.patch
drivers-char-memc-cleanups.patch
memcg-move-charges-of-anonymous-page.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-implement-memory-thresholds.patch
documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api.patch
pps-linuxpps-clients-support.patch
pps-serial-clients-support.patch
sysctl-extern-cleanup-binfmts.patch
sysctl-extern-cleanup-binfmts-fix.patch
sysctl-extern-cleanup-module-fix.patch
linux-next.patch
linux-next-fixups.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-i2c-busses-i2c-xiicc-is-borked.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
kernel-schedc-suppress-unused-var-warning.patch
usb-serial-ftdi-add-contec-vendor-and-product-id-fix.patch
drivers-char-tty_bufferc-fix-min-warnings.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
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

