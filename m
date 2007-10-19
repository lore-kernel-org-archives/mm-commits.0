From: akpm@linux-foundation.org
Subject: - intel-iommu-iommu-gfx-workaround-kconfig-fix.patch removed from -mm tree
Date: Fri, 19 Oct 2007 16:31:53 -0700
Message-ID: <200710192331.l9JNVriG025853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41006 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758313AbXJSXcE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:32:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@computergmbh.de, anil.s.keshavamurthy@intel.com, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     intel iommu: Kconfig fixes
has been removed from the -mm tree.  Its filename was
     intel-iommu-iommu-gfx-workaround-kconfig-fix.patch

This patch was dropped because it was folded into intel-iommu-iommu-gfx-workaround.patch

------------------------------------------------------
Subject: intel iommu: Kconfig fixes
From: Jan Engelhardt <jengelh@computergmbh.de>

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/Kconfig |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/x86_64/Kconfig~intel-iommu-iommu-gfx-workaround-kconfig-fix arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~intel-iommu-iommu-gfx-workaround-kconfig-fix
+++ a/arch/x86_64/Kconfig
@@ -755,11 +755,11 @@ config DMAR
 	depends on PCI_MSI && ACPI && EXPERIMENTAL
 	default y
 	help
-	  DMA remapping(DMAR) devices support enables independent address
-	  translations for Direct Memory Access(DMA) from Devices.
+	  DMA remapping (DMAR) devices support enables independent address
+	  translations for Direct Memory Access (DMA) from devices.
 	  These DMA remapping devices are reported via ACPI tables
-	  and includes pci device scope covered by these DMA
-	  remapping device.
+	  and include PCI device scope covered by these DMA
+	  remapping devices.
 
 config DMAR_GFX_WA
 	bool "Support for Graphics workaround"
@@ -767,9 +767,9 @@ config DMAR_GFX_WA
 	default y
 	help
 	 Current Graphics drivers tend to use physical address
-	 for DMA and avoid using DMA api's. Setting this config
+	 for DMA and avoid using DMA APIs. Setting this config
 	 option permits the IOMMU driver to set a unity map for
-	 all the OS visible memory. Hence the driver can continue
+	 all the OS-visible memory. Hence the driver can continue
 	 to use physical addresses for DMA.
 
 source "drivers/pci/pcie/Kconfig"
_

Patches currently in -mm which might be from jengelh@computergmbh.de are

origin.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-gfx-workaround-kconfig-fix.patch
intel-iommu-iommu-floppy-workaround-kconfig-fix.patch
