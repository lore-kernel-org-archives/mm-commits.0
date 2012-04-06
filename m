From: akpm@linux-foundation.org
Subject: [to-be-updated] leds-add-led-driver-for-lm3556-chip-fix-2.patch removed from -mm tree
Date: Fri, 06 Apr 2012 16:29:03 -0700
Message-ID: <20120406232903.802A4A0162@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:54487 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2DFX3G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Apr 2012 19:29:06 -0400
Received: by lboi15 with SMTP id i15so60724lbo.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Apr 2012 16:29:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axel.lin@gmail.com, daniel.jeong@ti.com, gshark.jeong@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: leds-add-led-driver-for-lm3556-chip-fix-2
has been removed from the -mm tree.  Its filename was
     leds-add-led-driver-for-lm3556-chip-fix-2.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: leds-add-led-driver-for-lm3556-chip-fix-2

include module.h

Cc: Axel Lin <axel.lin@gmail.com>
Cc: Daniel Jeong <daniel.jeong@ti.com>
Cc: Geon Si Jeong <gshark.jeong@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lm3556.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/leds/leds-lm3556.c~leds-add-led-driver-for-lm3556-chip-fix-2 drivers/leds/leds-lm3556.c
--- a/drivers/leds/leds-lm3556.c~leds-add-led-driver-for-lm3556-chip-fix-2
+++ a/drivers/leds/leds-lm3556.c
@@ -11,6 +11,7 @@
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/leds.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/types.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
percpu-remove-percpu_xxx-functions-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
leds-add-led-driver-for-lm3556-chip-fix.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
backlight-lcd-add-driver-for-raster-type-lcds-with-gpio-controlled-panel-reset-fix.patch

