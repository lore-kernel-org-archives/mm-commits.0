From: akpm@linux-foundation.org
Subject: + documentation-dma-api-howtotxt-minor-grammar-corrections.patch added to -mm tree
Date: Wed, 31 Oct 2012 13:57:19 -0700
Message-ID: <20121031205720.7B4235C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:57168 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760559Ab2JaU5W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 31 Oct 2012 16:57:22 -0400
Received: by mail-ea0-f202.google.com with SMTP id q10so120359eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 31 Oct 2012 13:57:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shuah.khan@hp.com


The patch titled
     Subject: Documentation/DMA-API-HOWTO.txt: minor grammar corrections
has been added to the -mm tree.  Its filename is
     documentation-dma-api-howtotxt-minor-grammar-corrections.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
documentation-dma-api-howtotxt-minor-grammar-corrections.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch

