From: akpm@linux-foundation.org
Subject: + intel-iommu-iommu-floppy-workaround-kconfig-fix.patch added to -mm tree
Date: Thu, 12 Jul 2007 16:23:55 -0700
Message-ID: <200707122323.l6CNNtYV010868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40902 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755939AbXGLXYH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jul 2007 19:24:07 -0400
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

 arch/x86_64/Kconfig |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/x86_64/Kconfig~intel-iommu-iommu-floppy-workaround-kconfig-fix arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~intel-iommu-iommu-floppy-workaround-kconfig-fix
+++ a/arch/x86_64/Kconfig
@@ -753,11 +753,11 @@ config DMAR
 	depends on PCI_MSI && ACPI && EXPERIMENTAL
 	default y
 	help
-	  DMA remapping (DMAR) devices support enables independent address
-	  translations for Direct Memory Access (DMA) from devices.
+	  DMA remapping(DMAR) devices support enables independent address
+	  translations for Direct Memory Access(DMA) from Devices.
 	  These DMA remapping devices are reported via ACPI tables
-	  and include PCI device scope covered by these DMA
-	  remapping devices.
+	  and includes pci device scope covered by these DMA
+	  remapping device.
 
 config DMAR_GFX_WA
 	bool "Support for Graphics workaround"
@@ -765,9 +765,9 @@ config DMAR_GFX_WA
 	default y
 	help
 	 Current Graphics drivers tend to use physical address
-	 for DMA and avoid using DMA APIs. Setting this config
+	 for DMA and avoid using DMA api's. Setting this config
 	 option permits the IOMMU driver to set a unity map for
-	 all the OS-visible memory. Hence the driver can continue
+	 all the OS visible memory. Hence the driver can continue
 	 to use physical addresses for DMA.
 
 config DMAR_FLOPPY_WA
_

Patches currently in -mm which might be from jengelh@computergmbh.de are

fix-gregkh-usb-usb-use-menuconfig-objects.patch
make-timespec_equal-take-const-arguments.patch
intel-iommu-iommu-gfx-workaround-kconfig-fix.patch
intel-iommu-iommu-floppy-workaround-kconfig-fix.patch
