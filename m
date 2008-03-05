From: akpm@linux-foundation.org
Subject: - alpha-remove-unused-debug_forcedac-define-in-iommu.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:44:58 -0800
Message-ID: <200803050744.m257iwq0021550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759366AbYCEHtl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:49:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: remove unused DEBUG_FORCEDAC define in IOMMU
has been removed from the -mm tree.  Its filename was
     alpha-remove-unused-debug_forcedac-define-in-iommu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: remove unused DEBUG_FORCEDAC define in IOMMU
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This just removes unused DEBUG_FORCEDAC define in the IOMMU code.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/pci_iommu.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/alpha/kernel/pci_iommu.c~alpha-remove-unused-debug_forcedac-define-in-iommu arch/alpha/kernel/pci_iommu.c
--- a/arch/alpha/kernel/pci_iommu.c~alpha-remove-unused-debug_forcedac-define-in-iommu
+++ a/arch/alpha/kernel/pci_iommu.c
@@ -31,7 +31,6 @@
 #endif
 
 #define DEBUG_NODIRECT 0
-#define DEBUG_FORCEDAC 0
 
 #define ISA_DMA_MASK		0x00ffffff
 
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

parisc-fix-a-overflow-bug-on-32bit-architectures.patch
git-scsi-misc.patch
mpt-fusion-dont-oops-if-numphys==0.patch

