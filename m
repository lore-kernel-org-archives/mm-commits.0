From: akpm@linux-foundation.org
Subject: [merged] arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch removed from -mm tree
Date: Thu, 09 Aug 2012 14:05:39 -0700
Message-ID: <20120809210542.0E468200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:62031 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab2HIVFp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2012 17:05:45 -0400
Received: by lbbge1 with SMTP id ge1so47910lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 09 Aug 2012 14:05:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, hpa@zytor.com, tglx@linutronix.de, zheng.z.yan@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/kernel/cpu/perf_event_intel_uncore.h: make UNCORE_PMU_HRTIMER_INTERVAL 64-bit
has been removed from the -mm tree.  Its filename was
     arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch/x86/kernel/cpu/perf_event_intel_uncore.h: make UNCORE_PMU_HRTIMER_INTERVAL 64-bit

i386 allmodconfig:

arch/x86/kernel/cpu/perf_event_intel_uncore.c: In function 'uncore_pmu_hrtimer':
arch/x86/kernel/cpu/perf_event_intel_uncore.c:728: warning: integer overflow in expression
arch/x86/kernel/cpu/perf_event_intel_uncore.c: In function 'uncore_pmu_start_hrtimer':
arch/x86/kernel/cpu/perf_event_intel_uncore.c:735: warning: integer overflow in expression

Cc: Zheng Yan <zheng.z.yan@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/perf_event_intel_uncore.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/cpu/perf_event_intel_uncore.h~arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit arch/x86/kernel/cpu/perf_event_intel_uncore.h
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h~arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit
+++ a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -5,7 +5,7 @@
 #include "perf_event.h"
 
 #define UNCORE_PMU_NAME_LEN		32
-#define UNCORE_PMU_HRTIMER_INTERVAL	(60 * NSEC_PER_SEC)
+#define UNCORE_PMU_HRTIMER_INTERVAL	(60LL * NSEC_PER_SEC)
 
 #define UNCORE_FIXED_EVENT		0xff
 #define UNCORE_PMC_IDX_MAX_GENERIC	8
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm-slab_commonc-fix-warning.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
rbtree-performance-and-correctness-test-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

