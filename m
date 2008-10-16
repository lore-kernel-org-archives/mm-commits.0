From: akpm@linux-foundation.org
Subject: + intel-iommu-typo-fix-and-correct-word-in-the-comment.patch added to -mm tree
Date: Thu, 16 Oct 2008 14:00:47 -0700
Message-ID: <200810162100.m9GL0lZU018999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755028AbYJPVAv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 17:00:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 2ameya@gmail.com, anil.s.keshavamurthy@intel.com, ashok.raj@intel.com, shaohua.li@intel.com


The patch titled
     intel-iommu: typo fix and correct word in the comment
has been added to the -mm tree.  Its filename is
     intel-iommu-typo-fix-and-correct-word-in-the-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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

intel-iommu-typo-fix-and-correct-word-in-the-comment.patch

