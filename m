From: akpm@linux-foundation.org
Subject: + include-linux-fsh-complete-hexification-of-fmode_-constants.patch added to -mm tree
Date: Tue, 09 Mar 2010 10:58:52 -0800
Message-ID: <201003091858.o29IwqFP030662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752552Ab0CIS7k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 13:59:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, eparis@redhat.com, fengguang.wu@intel.com


The patch titled
     include/linux/fs.h: complete hexification of FMODE_* constants
has been added to the -mm tree.  Its filename is
     include-linux-fsh-complete-hexification-of-fmode_-constants.patch

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
Subject: include/linux/fs.h: complete hexification of FMODE_* constants
From: Andrew Morton <akpm@linux-foundation.org>

One straggler which was missed due to merge ordering issues.

Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Eric Paris <eparis@redhat.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN Documentation/filesystems/proc.txt~include-linux-fsh-complete-hexification-of-fmode_-constants Documentation/filesystems/proc.txt
diff -puN include/linux/fs.h~include-linux-fsh-complete-hexification-of-fmode_-constants include/linux/fs.h
--- a/include/linux/fs.h~include-linux-fsh-complete-hexification-of-fmode_-constants
+++ a/include/linux/fs.h
@@ -91,7 +91,8 @@ struct inodes_stat_t {
 #define FMODE_RANDOM		((__force fmode_t)0x1000)
 
 /* File was opened by fanotify and shouldn't generate fanotify events */
-#define FMODE_NONOTIFY		((__force fmode_t)16777216) /* 0x1000000 */
+/* File was opened by fanotify and shouldn't generate fanotify events */
+#define FMODE_NONOTIFY		((__force fmode_t)0x1000000)
 
 /*
  * The below are the various read and write types that we support. Some of
diff -puN lib/Kconfig~include-linux-fsh-complete-hexification-of-fmode_-constants lib/Kconfig
diff -puN lib/Makefile~include-linux-fsh-complete-hexification-of-fmode_-constants lib/Makefile
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
bitops-rename-for_each_bit-to-for_each_set_bit-arm.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
3x59x-fix-pci-resource-management.patch
kernel-schedc-suppress-unused-var-warning.patch
usb-serial-ftdi-add-contec-vendor-and-product-id-fix.patch
drivers-watchdog-wdtc-wdt_ioctl-make-ident-non-static.patch
drivers-char-tty_bufferc-fix-min-warnings.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
add-generic-sys_ipc-wrapper-fix.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes.patch
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
bitops-remove-temporary-for_each_bit.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

