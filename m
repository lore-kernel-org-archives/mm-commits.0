From: akpm@linux-foundation.org
Subject: - intel-iommu-iommu-floppy-workaround-fix-fix.patch removed from -mm tree
Date: Mon, 09 Jul 2007 16:50:14 -0700
Message-ID: <200707092350.l69NoEZF021471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39358 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757301AbXGIXuY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 19:50:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anil.s.keshavamurthy@intel.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     Iommu floppy workaround fix 2
has been removed from the -mm tree.  Its filename was
     intel-iommu-iommu-floppy-workaround-fix-fix.patch

This patch was dropped because it was folded into intel-iommu-iommu-floppy-workaround.patch

------------------------------------------------------
Subject: Iommu floppy workaround fix 2
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>

Here goes the patch to make it user invisible config option.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86_64/Kconfig~intel-iommu-iommu-floppy-workaround-fix-fix arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~intel-iommu-iommu-floppy-workaround-fix-fix
+++ a/arch/x86_64/Kconfig
@@ -771,7 +771,7 @@ config DMAR_GFX_WA
 	 to use physical addresses for DMA.
 
 config DMAR_FLOPPY_WA
-	bool "Support for Floppy disk workaround"
+	bool
 	depends on DMAR
 	default y
 	help
_

Patches currently in -mm which might be from anil.s.keshavamurthy@intel.com are

jprobes-make-struct-jprobeentry-a-void.patch
jprobes-remove-jprobe_entry.patch
jprobes-make-jprobes-a-little-safer-for-users.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-iommu-floppy-workaround-fix-fix.patch
