From: akpm@linux-foundation.org
Subject: + arm-fix-header-guards.patch added to -mm tree
Date: Thu, 29 May 2008 00:33:53 -0700
Message-ID: <200805290733.m4T7XrN2022697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305AbYE2HeF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 May 2008 03:34:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vegard.nossum@gmail.com, dan.j.williams@intel.com, rmk@arm.linux.org.uk


The patch titled
     arm: fix header guards
has been added to the -mm tree.  Its filename is
     arm-fix-header-guards.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm: fix header guards
From: Vegard Nossum <vegard.nossum@gmail.com>

Cc: Dan Williams <dan.j.williams@intel.com>
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

mn10300-fix-typo-in-header-guard.patch
arm-fix-header-guards.patch
parisc-fix-incomplete-header-guard.patch
h8300-fix-typo-in-header-guard.patch
v850-fix-typo-in-header-guard.patch
kallsyms-fix-potential-overflow-in-binary-search.patch

