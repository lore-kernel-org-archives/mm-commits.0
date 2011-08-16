From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:51:00 -0700
Message-ID: <201108161848.p7GIm7Wn015234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752617Ab1HPSyh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:54:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axel.lin@gmail.com, jinyoungp@nvidia.com, rpurdie@rpsys.net, sameo@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/video/backlight/aat2870_bl.c: make it buildable as a module
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/backlight/aat2870_bl.c: make it buildable as a module
From: Andrew Morton <akpm@linux-foundation.org>

i386 allmodconfig:

drivers/built-in.o: In function `aat2870_bl_remove':
aat2870_bl.c:(.text+0x414f9): undefined reference to `backlight_device_unregister'
drivers/built-in.o: In function `aat2870_bl_probe':
aat2870_bl.c:(.text+0x418fc): undefined reference to `backlight_device_register'
aat2870_bl.c:(.text+0x41a31): undefined reference to `backlight_device_unregiste

Cc: Jin Park <jinyoungp@nvidia.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Axel Lin <axel.lin@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/Kconfig~drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module
+++ a/drivers/video/backlight/Kconfig
@@ -336,7 +336,7 @@ config BACKLIGHT_PCF50633
 	  enable its driver.
 
 config BACKLIGHT_AAT2870
-	bool "AnalogicTech AAT2870 Backlight"
+	tristate "AnalogicTech AAT2870 Backlight"
 	depends on BACKLIGHT_CLASS_DEVICE && MFD_AAT2870_CORE
 	help
 	  If you have a AnalogicTech AAT2870 say Y to enable the
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface-fix.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

