From: akpm@linux-foundation.org
Subject: + sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources-v2-fix.patch added to -mm tree
Date: Tue, 21 Aug 2012 14:16:03 -0700
Message-ID: <20120821220340.9D28420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57598 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758697Ab2HUWDn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Aug 2012 18:03:43 -0400
Received: by eekd4 with SMTP id d4so10099eek.1
        for <mm-commits@vger.kernel.org>; Tue, 21 Aug 2012 15:03:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, holt@sgi.com


The patch titled
     Subject: sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources-v2-fix
has been added to the -mm tree.  Its filename is
     sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources-v2-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-hugetlbfs-correctly-populate-shared-pmd-fix.patch
sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources-v2-fix.patch
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

