From: akpm@linux-foundation.org
Subject: [merged]
 arch-sh-drivers-pci-pcie-sh7786h-remove-duplicate-sh4a_pciephyctlr.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:29:55 -0700
Message-ID: <533f0833.F6gzsnaEQMciqTZp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42692 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387AbaDDT3z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:29:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, geert+renesas@glider.be

Subject: [merged] arch-sh-drivers-pci-pcie-sh7786h-remove-duplicate-sh4a_pciephyctlr.patch removed from -mm tree
To: geert+renesas@glider.be,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:29:55 -0700


The patch titled
     Subject: arch/sh/drivers/pci/pcie-sh7786.h: remove duplicate SH4A_PCIEPHYCTLR
has been removed from the -mm tree.  Its filename was
     arch-sh-drivers-pci-pcie-sh7786h-remove-duplicate-sh4a_pciephyctlr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: arch/sh/drivers/pci/pcie-sh7786.h: remove duplicate SH4A_PCIEPHYCTLR

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/drivers/pci/pcie-sh7786.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/sh/drivers/pci/pcie-sh7786.h~arch-sh-drivers-pci-pcie-sh7786h-remove-duplicate-sh4a_pciephyctlr arch/sh/drivers/pci/pcie-sh7786.h
--- a/arch/sh/drivers/pci/pcie-sh7786.h~arch-sh-drivers-pci-pcie-sh7786h-remove-duplicate-sh4a_pciephyctlr
+++ a/arch/sh/drivers/pci/pcie-sh7786.h
@@ -145,9 +145,6 @@
 /*	PCIERMSGIER	*/
 #define	SH4A_PCIERMSGIER	(0x004040)	/* R/W - 0x0000 0000 32 */
 
-/*	PCIEPHYCTLR	*/
-#define SH4A_PCIEPHYCTLR	(0x010000)	/* R/W - 0x0000 0000 32 */
