From: akpm@linux-foundation.org
Subject: + leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch added to -mm tree
Date: Tue, 02 Aug 2011 14:18:27 -0700
Message-ID: <201108022156.p72LuqLr016596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755442Ab1HBV5K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2011 17:57:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dmitry.torokhov@gmail.com, samuel.thibault@ens-lyon.org


The patch titled
     leds-route-kbd-leds-through-the-generic-leds-layer-fix
has been added to the -mm tree.  Its filename is
     leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch

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
Subject: leds-route-kbd-leds-through-the-generic-leds-layer-fix
From: Andrew Morton <akpm@linux-foundation.org>

x86_64 allmodconfig:

drivers/leds/leds-input.c:304: error: expected declaration specifiers or '...' before string constant
drivers/leds/leds-input.c:304: warning: data definition has no type or storage class
drivers/leds/leds-input.c:304: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
drivers/leds/leds-input.c:304: warning: function declaration isn't a prototype
drivers/leds/leds-input.c:305: error: expected declaration specifiers or '...' before string constant
drivers/leds/leds-input.c:305: warning: data definition has no type or storage class
drivers/leds/leds-input.c:305: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
drivers/leds/leds-input.c:305: warning: function declaration isn't a prototype
drivers/leds/leds-input.c:306: error: expected declaration specifiers or '...' before string constant
drivers/leds/leds-input.c:306: warning: data definition has no type or storage class
drivers/leds/leds-input.c:306: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
drivers/leds/leds-input.c:306: warning: function declaration isn't a prototype

Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-input.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/leds/leds-input.c~leds-route-kbd-leds-through-the-generic-leds-layer-fix drivers/leds/leds-input.c
--- a/drivers/leds/leds-input.c~leds-route-kbd-leds-through-the-generic-leds-layer-fix
+++ a/drivers/leds/leds-input.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/leds.h>
 #include <linux/input.h>
+#include <linux/module.h>
 
 #include "leds.h"
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch
drivers-cdrom-cdromc-relax-check-on-dvd-manufacturer-value.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch
drivers-staging-solo6x10-corec-needs-slabh.patch
drivers-staging-solo6x10-p2mc-needs-slabh.patch
staging-more-missing-slabh-inclusions.patch
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
kexec-remove-kmsg_dump_kexec.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

