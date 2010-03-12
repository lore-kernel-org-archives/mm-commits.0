From: akpm@linux-foundation.org
Subject: + of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch added to -mm tree
Date: Fri, 12 Mar 2010 13:08:02 -0800
Message-ID: <201003122108.o2CL824m008123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934582Ab0CLVI3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Mar 2010 16:08:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, avorontsov@ru.mvista.com, benh@kernel.crashing.org, bgat@billgatliff.com, dbaryshkov@gmail.com, dbrownell@users.sourceforge.net, grant.likely@secretlab.ca, khali@linux-fr.org


The patch titled
     of-gpio-implement-gpiolib-notifier-hooks-fix-fix2
has been added to the -mm tree.  Its filename is
     of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch

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
Subject: of-gpio-implement-gpiolib-notifier-hooks-fix-fix2
From: Andrew Morton <akpm@linux-foundation.org>

remove unusable module export.

Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bill Gatliff <bgat@billgatliff.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/of/gpio.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/of/gpio.c~of-gpio-implement-gpiolib-notifier-hooks-fix-fix2 drivers/of/gpio.c
--- a/drivers/of/gpio.c~of-gpio-implement-gpiolib-notifier-hooks-fix-fix2
+++ a/drivers/of/gpio.c
@@ -271,7 +271,6 @@ static int of_gpiochip_register_simple(s
 
 	return 0;
 }
-EXPORT_SYMBOL(of_gpiochip_register_simple);
 
 /**
  * of_gpiochip_unregister - Unregister a GPIO chip
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
linux-next.patch
linux-next-fixups.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-crypto-aesni-intel_asms-make-it-build.patch
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
usb-serial-ftdi-add-contec-vendor-and-product-id.patch
drivers-char-tty_bufferc-fix-min-warnings.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
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

