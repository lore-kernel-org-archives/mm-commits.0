From: akpm@linux-foundation.org
Subject: + intel-iommu-iommu-floppy-workaround-fix-fix.patch added to -mm tree
Date: Tue, 26 Jun 2007 12:38:31 -0700
Message-ID: <200706261938.l5QJcVuI000732@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49176 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756770AbXFZTil (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 15:38:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anil.s.keshavamurthy@intel.com, ak@suse.de


The patch titled
     Iommu floppy workaround fix 2
has been added to the -mm tree.  Its filename is
     intel-iommu-iommu-floppy-workaround-fix-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
jprobes-make-jprobes-a-little-safer-for-users-fix.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-pci-generic-helper-function-fix.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-iova-allocation-and-management-routines-fix.patch
intel-iommu-iova-allocation-and-management-routines-fix-2.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-intel-iommu-driver-fix.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-iommu-floppy-workaround-fix.patch
intel-iommu-iommu-floppy-workaround-fix-fix.patch
