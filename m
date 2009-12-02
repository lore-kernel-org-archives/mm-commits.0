From: akpm@linux-foundation.org
Subject: [to-be-updated] documentation-dma-apitxt-fix-a-stale-reference.patch removed from -mm tree
Date: Wed, 02 Dec 2009 14:46:22 -0800
Message-ID: <200912022246.nB2MkMTM001567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754388AbZLBWqT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2009 17:46:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bart.vanassche@gmail.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Documentation/DMA-API.txt: fix a stale reference
has been removed from the -mm tree.  Its filename was
     documentation-dma-apitxt-fix-a-stale-reference.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/DMA-API.txt: fix a stale reference
From: Bart Van Assche <bart.vanassche@gmail.com>

Fixes a stale reference in Documentation/DMA-API.txt.

Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/DMA-API.txt~documentation-dma-apitxt-fix-a-stale-reference Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~documentation-dma-apitxt-fix-a-stale-reference
+++ a/Documentation/DMA-API.txt
@@ -5,7 +5,7 @@
 
 This document describes the DMA API.  For a more gentle introduction
 phrased in terms of the pci_ equivalents (and actual examples) see
-Documentation/PCI/PCI-DMA-mapping.txt.
+Documentation/DMA-mapping.txt.
 
 This API is split into two pieces.  Part I describes the API and the
 corresponding pci_ API.  Part II describes the extensions to the API
_

Patches currently in -mm which might be from bart.vanassche@gmail.com are

readahead-add-blk_run_backing_dev.patch
documentation-dma-apitxt-fix-a-stale-reference.patch

