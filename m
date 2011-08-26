From: akpm@linux-foundation.org
Subject: [merged] printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel-fix-fix.patch removed from -mm tree
Date: Fri, 26 Aug 2011 12:07:14 -0700
Message-ID: <201108261903.p7QJ3w7m005742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753532Ab1HZTE3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 15:04:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, yanmin_zhang@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel-fix-fix
has been removed from the -mm tree.  Its filename was
     printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel-fix-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Cc: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk.c~printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel-fix-fix kernel/printk.c
--- a/kernel/printk.c~printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel-fix-fix
+++ a/kernel/printk.c
@@ -24,7 +24,7 @@
 #include <linux/init.h>
 #include <linux/jiffies.h>
 #include <linux/nmi.h>
-#include <linux/export.h>
+#include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/interrupt.h>			/* For in_interrupt() */
 #include <linux/delay.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled-fix.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface-fix.patch
kernel-rtmutexc-fix-warning-improve-coding-style.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements-checkpatch-fixes.patch
mm.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap-fix.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-neaten-warn_alloc_failed-fix.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
fs-nameic-remove-unused-getname_flags.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
nbd-replace-some-printk-with-dev_warn-and-dev_info-checkpatch-fixes.patch
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

