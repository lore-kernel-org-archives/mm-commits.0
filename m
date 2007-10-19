From: akpm@linux-foundation.org
Subject: - intel-iommu-iommu-floppy-workaround-kconfig-fix.patch removed from -mm tree
Date: Fri, 19 Oct 2007 16:32:20 -0700
Message-ID: <200710192332.l9JNWKbH025888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50578 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761378AbXJSXc0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:32:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@computergmbh.de, anil.s.keshavamurthy@intel.com, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     intel iommu: Kconfig fixes
has been removed from the -mm tree.  Its filename was
     intel-iommu-iommu-floppy-workaround-kconfig-fix.patch

This patch was dropped because it was folded into intel-iommu-iommu-floppy-workaround.patch

------------------------------------------------------
Subject: intel iommu: Kconfig fixes
From: Jan Engelhardt <jengelh@computergmbh.de>

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86_64/Kconfig~intel-iommu-iommu-floppy-workaround-kconfig-fix arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~intel-iommu-iommu-floppy-workaround-kconfig-fix
+++ a/arch/x86_64/Kconfig
@@ -777,10 +777,10 @@ config DMAR_FLOPPY_WA
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

origin.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-iommu-floppy-workaround-kconfig-fix.patch
