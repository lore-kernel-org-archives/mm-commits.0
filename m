From: akpm@linux-foundation.org
Subject: + documentation-dma-api-howtotxt-add-multiple-types-of-iommus-support.patch added to -mm tree
Date: Thu, 29 Jul 2010 12:52:44 -0700
Message-ID: <201007291952.o6TJqiOt030285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751828Ab0G2TxM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jul 2010 15:53:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp


The patch titled
     Documentation: DMA-API-HOWTO.txt: add multiple types of IOMMUs support
has been added to the -mm tree.  Its filename is
     documentation-dma-api-howtotxt-add-multiple-types-of-iommus-support.patch

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
Subject: Documentation: DMA-API-HOWTO.txt: add multiple types of IOMMUs support
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API-HOWTO.txt |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN Documentation/DMA-API-HOWTO.txt~documentation-dma-api-howtotxt-add-multiple-types-of-iommus-support Documentation/DMA-API-HOWTO.txt
--- a/Documentation/DMA-API-HOWTO.txt~documentation-dma-api-howtotxt-add-multiple-types-of-iommus-support
+++ a/Documentation/DMA-API-HOWTO.txt
@@ -753,6 +753,16 @@ to "Closing".
    alignment constraints (e.g. the alignment constraints about 64-bit
    objects).
 
+3) Supporting multiple types of IOMMUs
+
+   If your architecture needs to support multiple types of IOMMUs, you
+   can use include/linux/asm-generic/dma-mapping-common.h. It's a
+   library to support the DMA API with multiple types of IOMMUs. Lots
+   of architectures (x86, powerpc, sh, alpha, ia64, microblaze and
+   sparc) use it. Choose one to see how it can be used. If you need to
+   support multiple types of IOMMUs in a single system, the example of
+   x86 or powerpc helps.
+
 			   Closing
 
 This document, and the API itself, would not be in its current
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign.patch
dma-mapping-unify-dma_get_cache_alignment-implementations.patch
dma-mapping-parisc-set-arch_dma_minalign.patch
drivers-scsi-53c700c-remove-dma_is_consistent-usage.patch
dma-mapping-remove-dma_is_consistent-api.patch
documentation-dma-api-howtotxt-add-multiple-types-of-iommus-support.patch
pci-add-pci-dma-unamp-state-api-to-feature-removal-scheduletxt.patch

