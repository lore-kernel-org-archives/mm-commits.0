From: akpm@linux-foundation.org
Subject: [merged] documentation-dma-api-howtotxt-minor-grammar-corrections.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:11:27 -0800
Message-ID: <20130228201127.9A0CC5A4242@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:63654 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3B1UL2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:11:28 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so244939yen.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:11:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shuah.khan@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/DMA-API-HOWTO.txt: minor grammar corrections
has been removed from the -mm tree.  Its filename was
     documentation-dma-api-howtotxt-minor-grammar-corrections.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shuah Khan <shuah.khan@hp.com>
Subject: Documentation/DMA-API-HOWTO.txt: minor grammar corrections

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API-HOWTO.txt |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN Documentation/DMA-API-HOWTO.txt~documentation-dma-api-howtotxt-minor-grammar-corrections Documentation/DMA-API-HOWTO.txt
--- a/Documentation/DMA-API-HOWTO.txt~documentation-dma-api-howtotxt-minor-grammar-corrections
+++ a/Documentation/DMA-API-HOWTO.txt
@@ -488,9 +488,10 @@ will invoke the generic mapping error ch
 that the mapping code will work correctly on all dma implementations without
 any dependency on the specifics of the underlying implementation. Using the
 returned address without checking for errors could result in failures ranging
-from panics to silent data corruption. Couple of example of incorrect ways to
-check for errors that make assumptions about the underlying dma implementation
-are as follows and these are applicable to dma_map_page() as well.
+from panics to silent data corruption. A couple of examples of incorrect ways
+to check for errors that make assumptions about the underlying dma
+implementation are as follows and these are applicable to dma_map_page() as
+well.
 
 Incorrect example 1:
 	dma_addr_t dma_handle;
_

Patches currently in -mm which might be from shuah.khan@hp.com are

origin.patch
linux-next.patch

