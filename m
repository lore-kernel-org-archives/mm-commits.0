From: akpm@linux-foundation.org
Subject: [merged] include-linux-dmarh-forward-declare-struct-acpi_dmar_header.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:07:10 -0700
Message-ID: <201111012107.pA1L7A59015453@hpaq5.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:28324 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1KAVHW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:07:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mingo@redhat.com, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/dmar.h: forward-declare struct acpi_dmar_header
has been removed from the -mm tree.  Its filename was
     include-linux-dmarh-forward-declare-struct-acpi_dmar_header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/dmar.h: forward-declare struct acpi_dmar_header

x86_64 allnoconfig:

In file included from arch/x86/kernel/pci-dma.c:3:
include/linux/dmar.h:248: warning: 'struct acpi_dmar_header' declared inside parameter list
include/linux/dmar.h:248: warning: its scope is only this definition or declaration, which is probably not what you want

Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dmar.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/dmar.h~include-linux-dmarh-forward-declare-struct-acpi_dmar_header include/linux/dmar.h
--- a/include/linux/dmar.h~include-linux-dmarh-forward-declare-struct-acpi_dmar_header
+++ a/include/linux/dmar.h
@@ -26,6 +26,8 @@
 #include <linux/msi.h>
 #include <linux/irqreturn.h>
 
+struct acpi_dmar_header;
+
 /* DMAR Flags */
 #define DMAR_INTR_REMAP		0x1
 #define DMAR_X2APIC_OPT_OUT	0x2
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
readlinkat-ensure-we-return-enoent-for-the-empty-pathname-for-normal-lookups.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes-fix.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup-fix.patch
drivers-net-ethernet-oki-semi-pch_gbe-pch_gbeh-remove-unused-macro-pr_fmt.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
kexec-remove-kmsg_dump_kexec.patch
sysctl-add-support-for-poll-fix.patch
include-linux-dma-mappingh-add-dma_zalloc_coherent.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

