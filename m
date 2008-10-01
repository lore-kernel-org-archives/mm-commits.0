From: akpm@linux-foundation.org
Subject: - documentation-dma-mappingtxt-update-for-pci_dma_mapping_error-changes.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:49:55 -0700
Message-ID: <200810012149.m91Lnt5r005798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753600AbYJAVuW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:50:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mitov@issp.bas.bg, fujita.tomonori@lab.ntt.co.jp, mitov@ispp.bas.bg, mm-commits@vger.kernel.org


The patch titled
     Documentation/DMA-mapping.txt: update for pci_dma_mapping_error() changes
has been removed from the -mm tree.  Its filename was
     documentation-dma-mappingtxt-update-for-pci_dma_mapping_error-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/DMA-mapping.txt: update for pci_dma_mapping_error() changes
From: Marin Mitov <mitov@issp.bas.bg>

Make the example code consistent with changed API.

Signed-off-by: Marin Mitov <mitov@ispp.bas.bg>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-mapping.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/DMA-mapping.txt~documentation-dma-mappingtxt-update-for-pci_dma_mapping_error-changes Documentation/DMA-mapping.txt
--- a/Documentation/DMA-mapping.txt~documentation-dma-mappingtxt-update-for-pci_dma_mapping_error-changes
+++ a/Documentation/DMA-mapping.txt
@@ -740,7 +740,7 @@ failure can be determined by:
 	dma_addr_t dma_handle;
 
 	dma_handle = pci_map_single(pdev, addr, size, direction);
-	if (pci_dma_mapping_error(dma_handle)) {
+	if (pci_dma_mapping_error(pdev, dma_handle)) {
 		/*
 		 * reduce current DMA mapping usage,
 		 * delay and try again later or
_

Patches currently in -mm which might be from mitov@issp.bas.bg are


