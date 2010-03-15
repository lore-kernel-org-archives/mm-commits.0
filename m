From: akpm@linux-foundation.org
Subject: [merged] documentation-rename-pci-dma-mappingtxt-to-dma-api-howtotxt.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:04:01 -0400
Message-ID: <201003150704.o2F74Ys4017024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758870Ab0COHEl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:04:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, davem@davemloft.net, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Documentation: rename PCI-DMA-mapping.txt to DMA-API-HOWTO.txt
has been removed from the -mm tree.  Its filename was
     documentation-rename-pci-dma-mappingtxt-to-dma-api-howtotxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation: rename PCI-DMA-mapping.txt to DMA-API-HOWTO.txt
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/DMA-API.txt~documentation-rename-pci-dma-mappingtxt-to-dma-api-howtotxt Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~documentation-rename-pci-dma-mappingtxt-to-dma-api-howtotxt
+++ a/Documentation/DMA-API.txt
@@ -5,7 +5,7 @@
 
 This document describes the DMA API.  For a more gentle introduction
 of the API (and actual examples) see
-Documentation/PCI/PCI-DMA-mapping.txt.
+Documentation/DMA-API-HOWTO.txt.
 
 This API is split into two pieces.  Part I describes the API.  Part II
 describes the extensions to the API for supporting non-consistent
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch

