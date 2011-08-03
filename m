From: akpm@linux-foundation.org
Subject: [merged] staging-more-missing-slabh-inclusions.patch removed from -mm tree
Date: Wed, 03 Aug 2011 12:00:14 -0700
Message-ID: <201108031857.p73Ivh9p006756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755380Ab1HCS6Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2011 14:58:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     staging: more missing slab.h inclusions
has been removed from the -mm tree.  Its filename was
     staging-more-missing-slabh-inclusions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: staging: more missing slab.h inclusions
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/solo6x10/enc.c  |    1 +
 drivers/staging/solo6x10/g723.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/staging/solo6x10/enc.c~staging-more-missing-slabh-inclusions drivers/staging/solo6x10/enc.c
--- a/drivers/staging/solo6x10/enc.c~staging-more-missing-slabh-inclusions
+++ a/drivers/staging/solo6x10/enc.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include "solo6x10.h"
 #include "osd-font.h"
 
diff -puN drivers/staging/solo6x10/g723.c~staging-more-missing-slabh-inclusions drivers/staging/solo6x10/g723.c
--- a/drivers/staging/solo6x10/g723.c~staging-more-missing-slabh-inclusions
+++ a/drivers/staging/solo6x10/g723.c
@@ -21,6 +21,7 @@
 #include <linux/mempool.h>
 #include <linux/poll.h>
 #include <linux/kthread.h>
+#include <linux/slab.h>
 #include <linux/freezer.h>
 #include <sound/core.h>
 #include <sound/initval.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory-fix.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-mrst-pmuc-needs-moduleh.patch
cris-fix-a-build-error-in-kernel-forkc.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface-fix.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch
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

