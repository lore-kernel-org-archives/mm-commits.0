From: akpm@linux-foundation.org
Subject: +
 arch-sh-drivers-pci-pcie-sh7786h-remove-duplicate-sh4a_pciephyctlr.patch
 added to -mm tree
Date: Fri, 28 Mar 2014 13:58:32 -0700
Message-ID: <5335e278.vUVS6S1nILL8aCia%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53437 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbaC1U6c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Mar 2014 16:58:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, geert+renesas@glider.be

Subject: + arch-sh-drivers-pci-pcie-sh7786h-remove-duplicate-sh4a_pciephyctlr.patch added to -mm tree
To: geert+renesas@glider.be
From: akpm@linux-foundation.org
Date: Fri, 28 Mar 2014 13:58:32 -0700


The patch titled
     Subject: arch/sh/drivers/pci/pcie-sh7786.h: remove duplicate SH4A_PCIEPHYCTLR
has been added to the -mm tree.  Its filename is
     arch-sh-drivers-pci-pcie-sh7786h-remove-duplicate-sh4a_pciephyctlr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-sh-drivers-pci-pcie-sh7786h-remove-duplicate-sh4a_pciephyctlr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-sh-drivers-pci-pcie-sh7786h-remove-duplicate-sh4a_pciephyctlr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
