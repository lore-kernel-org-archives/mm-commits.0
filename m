From: akpm@linux-foundation.org
Subject: + replace-all-dma_35bit_mask-macro-with-dma_bit_mask35.patch added to -mm tree
Date: Thu, 19 Feb 2009 15:14:29 -0800
Message-ID: <200902192314.n1JNETYw029797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755003AbZBSXPE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 18:15:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yanghy@cn.fujitsu.com


The patch titled
     dma-mapping: replace all DMA_35BIT_MASK macro with DMA_BIT_MASK(35)
has been added to the -mm tree.  Its filename is
     replace-all-dma_35bit_mask-macro-with-dma_bit_mask35.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: replace all DMA_35BIT_MASK macro with DMA_BIT_MASK(35)
From: Yang Hongyang <yanghy@cn.fujitsu.com>

Replace all DMA_35BIT_MASK macro with DMA_BIT_MASK(35)

Signed-off-by: Yang Hongyang<yanghy@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/netxen/netxen_nic_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/netxen/netxen_nic_main.c~replace-all-dma_35bit_mask-macro-with-dma_bit_mask35 drivers/net/netxen/netxen_nic_main.c
--- a/drivers/net/netxen/netxen_nic_main.c~replace-all-dma_35bit_mask-macro-with-dma_bit_mask35
+++ a/drivers/net/netxen/netxen_nic_main.c
@@ -183,8 +183,8 @@ static int nx_set_dma_mask(struct netxen
 		adapter->dma_mask = DMA_BIT_MASK(39);
 		mask = DMA_BIT_MASK(39);
 	} else if (revision_id == NX_P2_C1) {
-		adapter->dma_mask = DMA_35BIT_MASK;
-		mask = DMA_35BIT_MASK;
+		adapter->dma_mask = DMA_BIT_MASK(35);
+		mask = DMA_BIT_MASK(35);
 	} else {
 		adapter->dma_mask = DMA_32BIT_MASK;
 		mask = DMA_32BIT_MASK;
_

Patches currently in -mm which might be from yanghy@cn.fujitsu.com are

replace-all-dma_64bit_mask-macro-with-dma_bit_mask64.patch
replace-all-dma_48bit_mask-macro-with-dma_bit_mask48.patch
replace-all-dma_40bit_mask-macro-with-dma_bit_mask40.patch
replace-all-dma_39bit_mask-macro-with-dma_bit_mask39.patch
replace-all-dma_35bit_mask-macro-with-dma_bit_mask35.patch
replace-all-dma_32bit_mask-macro-with-dma_bit_mask32.patch
replace-all-dma_31bit_mask-macro-with-dma_bit_mask31.patch
replace-all-dma_30bit_mask-macro-with-dma_bit_mask30.patch
replace-all-dma_28bit_mask-macro-with-dma_bit_mask28.patch
replace-all-dma_24bit_mask-macro-with-dma_bit_mask24.patch
update-the-old-macro-dma_nbit_mask-related-documentations.patch

