From: akpm@linux-foundation.org
Subject: [merged] arch-x86-platform-mrst-pmuc-needs-moduleh.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:51:35 -0700
Message-ID: <201108161848.p7GImgIi015372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752217Ab1HPSye (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:54:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hpa@zytor.com, len.brown@intel.com, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     arch/x86/platform/mrst/pmu.c needs module.h
has been removed from the -mm tree.  Its filename was
     arch-x86-platform-mrst-pmuc-needs-moduleh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/platform/mrst/pmu.c needs module.h
From: Andrew Morton <akpm@linux-foundation.org>

linux-next i386 allmodconfig:

arch/x86/platform/mrst/pmu.c:739: warning: data definition has no type or storage class
arch/x86/platform/mrst/pmu.c:739: warning: type defaults to 'int' in declaration of 'MODULE_DEVICE_TABLE'
arch/x86/platform/mrst/pmu.c:739: warning: parameter names (without types) in function declaration

Cc: Len Brown <len.brown@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/mrst/pmu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/platform/mrst/pmu.c~arch-x86-platform-mrst-pmuc-needs-moduleh arch/x86/platform/mrst/pmu.c
--- a/arch/x86/platform/mrst/pmu.c~arch-x86-platform-mrst-pmuc-needs-moduleh
+++ a/arch/x86/platform/mrst/pmu.c
@@ -21,6 +21,7 @@
 #include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/seq_file.h>
 #include <linux/sfi.h>
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

