From: akpm@linux-foundation.org
Subject: [folded] sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources-v2-fix.patch removed from -mm tree
Date: Tue, 21 Aug 2012 16:12:08 -0700
Message-ID: <20120821231208.EAC41100049@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-iy0-f202.google.com ([209.85.210.202]:41286 "EHLO
	mail-iy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab2HUXMK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Aug 2012 19:12:10 -0400
Received: by ialo24 with SMTP id o24so92982ial.1
        for <mm-commits@vger.kernel.org>; Tue, 21 Aug 2012 16:12:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, holt@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources-v2-fix
has been removed from the -mm tree.  Its filename was
     sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources-v2-fix.patch

This patch was dropped because it was folded into sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources-v2-fix

fix build: include cpu.h and module.h

Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc_uv.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/misc/sgi-xp/xpc_uv.c~sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources-v2-fix drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources-v2-fix
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -18,6 +18,8 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/cpu.h>
+#include <linux/module.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <asm/uv/uv_hub.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-hugetlbfs-correctly-populate-shared-pmd.patch
sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
rbtree-performance-and-correctness-test-fix.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

