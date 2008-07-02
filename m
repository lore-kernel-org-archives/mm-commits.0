From: akpm@linux-foundation.org
Subject: - arm-fix-header-guards.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:46:57 -0700
Message-ID: <200807020746.m627kvBh005606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750891AbYGBHrc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:47:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@gmail.com, dan.j.williams@intel.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     arm: fix header guards
has been removed from the -mm tree.  Its filename was
     arm-fix-header-guards.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm: fix header guards
From: Vegard Nossum <vegard.nossum@gmail.com>

Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-arm/arch-iop13xx/dma.h |    2 +-
 include/asm-arm/arch-msm/irqs.h    |    1 +
 include/asm-arm/arch-msm/timex.h   |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/asm-arm/arch-iop13xx/dma.h~arm-fix-header-guards include/asm-arm/arch-iop13xx/dma.h
--- a/include/asm-arm/arch-iop13xx/dma.h~arm-fix-header-guards
+++ a/include/asm-arm/arch-iop13xx/dma.h
@@ -1,3 +1,3 @@
 #ifndef _IOP13XX_DMA_H
-#define _IOP13XX_DMA_H_
+#define _IOP13XX_DMA_H
 #endif
diff -puN include/asm-arm/arch-msm/irqs.h~arm-fix-header-guards include/asm-arm/arch-msm/irqs.h
--- a/include/asm-arm/arch-msm/irqs.h~arm-fix-header-guards
+++ a/include/asm-arm/arch-msm/irqs.h
@@ -15,6 +15,7 @@
  */
 
 #ifndef __ASM_ARCH_MSM_IRQS_H
+#define __ASM_ARCH_MSM_IRQS_H
 
 /* MSM ARM11 Interrupt Numbers */
 /* See 80-VE113-1 A, pp219-221     */
diff -puN include/asm-arm/arch-msm/timex.h~arm-fix-header-guards include/asm-arm/arch-msm/timex.h
--- a/include/asm-arm/arch-msm/timex.h~arm-fix-header-guards
+++ a/include/asm-arm/arch-msm/timex.h
@@ -14,6 +14,7 @@
  */
 
 #ifndef __ASM_ARCH_MSM_TIMEX_H
+#define __ASM_ARCH_MSM_TIMEX_H
 
 #define CLOCK_TICK_RATE		1000000
 
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

origin.patch
linux-next.patch
git-kbuild-next.patch
parisc-fix-incomplete-header-guard.patch
mm-remove-initialization-of-static-per-cpu-variables.patch
kallsyms-fix-potential-overflow-in-binary-search.patch
kallsyms-unify-32-and-64-bit-code.patch
quota-cleanup-loop-in-sync_dquots.patch
quota-move-function-macros-from-quotah-to-quotaopsh-fix.patch
workqueues-make-get_online_cpus-useable-for-work-func.patch
s390-topology-dont-use-kthread-for-arch_reinit_sched_domains.patch
taskstats-remove-initialization-of-static-per-cpu-variable.patch

