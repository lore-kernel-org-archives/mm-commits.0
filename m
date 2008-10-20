From: akpm@linux-foundation.org
Subject: - intel-iommu-typo-fix-and-correct-word-in-the-comment.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:34:47 -0700
Message-ID: <200810202034.m9KKYlWh010930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754163AbYJTUqu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 2ameya@gmail.com, anil.s.keshavamurthy@intel.com, ashok.raj@intel.com, shaohua.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     intel-iommu: typo fix and correct word in the comment
has been removed from the -mm tree.  Its filename was
     intel-iommu-typo-fix-and-correct-word-in-the-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: intel-iommu: typo fix and correct word in the comment
From: "Ameya Palande" <2ameya@gmail.com>

Fix for a typo and and replacing incorrect word in the comment.

Signed-off-by: Ameya Palande <2ameya@gmail.com>
Cc: "Ashok Raj" <ashok.raj@intel.com>
Cc: "Shaohua Li" <shaohua.li@intel.com>
Cc: "Anil S Keshavamurthy" <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/intel-iommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/pci/intel-iommu.c~intel-iommu-typo-fix-and-correct-word-in-the-comment drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~intel-iommu-typo-fix-and-correct-word-in-the-comment
+++ a/drivers/pci/intel-iommu.c
@@ -563,7 +563,7 @@ static int __iommu_flush_context(struct 
 
 	spin_unlock_irqrestore(&iommu->register_lock, flag);
 
-	/* flush context entry will implictly flush write buffer */
+	/* flush context entry will implicitly flush write buffer */
 	return 0;
 }
 
@@ -656,7 +656,7 @@ static int __iommu_flush_iotlb(struct in
 	if (DMA_TLB_IAIG(val) != DMA_TLB_IIRG(type))
 		pr_debug("IOMMU: tlb flush request %Lx, actual %Lx\n",
 			DMA_TLB_IIRG(type), DMA_TLB_IAIG(val));
-	/* flush context entry will implictly flush write buffer */
+	/* flush iotlb entry will implicitly flush write buffer */
 	return 0;
 }
 
_

Patches currently in -mm which might be from 2ameya@gmail.com are

origin.patch

