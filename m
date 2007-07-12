From: akpm@linux-foundation.org
Subject: + intel-iommu-iommu-floppy-workaround-kconfig-fix.patch added to -mm tree
Date: Thu, 12 Jul 2007 16:26:06 -0700
Message-ID: <200707122326.l6CNQ71s011032@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57511 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757408AbXGLX0S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jul 2007 19:26:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@computergmbh.de, anil.s.keshavamurthy@intel.com, jengelh@gmx.de


The patch titled
     intel iommu: Kconfig fixes
has been added to the -mm tree.  Its filename is
     intel-iommu-iommu-floppy-workaround-kconfig-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: intel iommu: Kconfig fixes
From: Jan Engelhardt <jengelh@computergmbh.de>

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/Kconfig |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86_64/Kconfig~intel-iommu-iommu-floppy-workaround-kconfig-fix arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~intel-iommu-iommu-floppy-workaround-kconfig-fix
+++ a/arch/x86_64/Kconfig
@@ -775,10 +775,10 @@ config DMAR_FLOPPY_WA
 	depends on DMAR
 	default y
 	help
-	 Floppy disk drivers are know to by pass dma api calls
-	 their by failing to work when IOMMU is enabled. This
-	 work around will setup a 1 to 1 mappings for the first
-	 16M to make floppy(isa device) work.
+	 Floppy disk drivers are know to bypass DMA API calls
+	 thereby failing to work when IOMMU is enabled. This
+	 workaround will setup a 1:1 mapping for the first
+	 16M to make floppy (an ISA device) work.
 
 source "drivers/pci/pcie/Kconfig"
 
_

Patches currently in -mm which might be from jengelh@computergmbh.de are

fix-gregkh-usb-usb-use-menuconfig-objects.patch
make-timespec_equal-take-const-arguments.patch
intel-iommu-iommu-gfx-workaround-kconfig-fix.patch
intel-iommu-iommu-floppy-workaround-kconfig-fix.patch
