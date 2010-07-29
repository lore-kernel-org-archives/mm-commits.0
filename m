From: akpm@linux-foundation.org
Subject: + pci-add-pci-dma-unamp-state-api-to-feature-removal-scheduletxt.patch added to -mm tree
Date: Thu, 29 Jul 2010 12:52:46 -0700
Message-ID: <201007291952.o6TJqk21030288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757630Ab0G2TxS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jul 2010 15:53:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, jbarnes@virtuousgeek.org


The patch titled
     pci: add PCI DMA unamp state API to feature-removal-schedule.txt
has been added to the -mm tree.  Its filename is
     pci-add-pci-dma-unamp-state-api-to-feature-removal-scheduletxt.patch

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
Subject: pci: add PCI DMA unamp state API to feature-removal-schedule.txt
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

It was replaced with the DMA unamp state API (which can be used for
any bus).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN Documentation/feature-removal-schedule.txt~pci-add-pci-dma-unamp-state-api-to-feature-removal-scheduletxt Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~pci-add-pci-dma-unamp-state-api-to-feature-removal-scheduletxt
+++ a/Documentation/feature-removal-schedule.txt
@@ -532,3 +532,12 @@ Why:	superseded by acpi_sleep=nonvs
 Who:	Rafael J. Wysocki <rjw@sisk.pl>
 
 ----------------------------
+
+What: 	PCI DMA unmap state API
+When:	August 2012
+Why:	PCI DMA unmap state API (include/linux/pci-dma.h) was replaced
+	with DMA unmap state API (DMA unmap state API can be used for
+	any bus).
+Who:	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
+
+----------------------------
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

