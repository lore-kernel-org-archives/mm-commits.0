From: akpm@linux-foundation.org
Subject: + dma-mapping-add-dma_xxbit_mask-to-feature-removal-scheduletxt.patch added to -mm tree
Date: Fri, 30 Jul 2010 14:28:44 -0700
Message-ID: <201007302128.o6ULSiJx001385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752346Ab0G3V3F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jul 2010 17:29:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp


The patch titled
     dma-mapping: add DMA_xxBIT_MASK to feature-removal-schedule.txt
has been added to the -mm tree.  Its filename is
     dma-mapping-add-dma_xxbit_mask-to-feature-removal-scheduletxt.patch

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
Subject: dma-mapping: add DMA_xxBIT_MASK to feature-removal-schedule.txt
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

DMA_xxBIT_MASK macros were marked as deprecated in June 2009.  One more
year is long enough, I think.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN Documentation/feature-removal-schedule.txt~dma-mapping-add-dma_xxbit_mask-to-feature-removal-scheduletxt Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~dma-mapping-add-dma_xxbit_mask-to-feature-removal-scheduletxt
+++ a/Documentation/feature-removal-schedule.txt
@@ -562,3 +562,11 @@ Why:	PCI DMA unmap state API (include/li
 Who:	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
 
 ----------------------------
+
+What: 	DMA_xxBIT_MASK macros
+When:	Jun 2011
+Why:	DMA_xxBIT_MASK macros were replaced with DMA_BIT_MASK() macros.
+Who:	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
+
+----------------------------
+
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
dma-mapping-add-dma_xxbit_mask-to-feature-removal-scheduletxt.patch

