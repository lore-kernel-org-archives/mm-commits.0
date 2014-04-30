From: akpm@linux-foundation.org
Subject: + intel-iommu-integrate-dma-cma-fix.patch added to -mm tree
Date: Wed, 30 Apr 2014 15:36:14 -0700
Message-ID: <53617ade.pf+YxZFjQz8jQ3cH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759613AbaD3WgP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Apr 2014 18:36:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, akinobu.mita@gmail.com

Subject: + intel-iommu-integrate-dma-cma-fix.patch added to -mm tree
To: akinobu.mita@gmail.com,fengguang.wu@intel.com
From: akpm@linux-foundation.org
Date: Wed, 30 Apr 2014 15:36:14 -0700


The patch titled
     Subject: intel-iommu: add missing include of dma-contiguous.h
has been added to the -mm tree.  Its filename is
     intel-iommu-integrate-dma-cma-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/intel-iommu-integrate-dma-cma-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/intel-iommu-integrate-dma-cma-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: intel-iommu: add missing include of dma-contiguous.h

This patch fixes build error on ia64, that is introduced by the patch
intel-iommu-integrate-dma-cma.patch in -mm tree, and this change should
be folded into it.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/intel-iommu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/iommu/intel-iommu.c~intel-iommu-integrate-dma-cma-fix drivers/iommu/intel-iommu.c
--- a/drivers/iommu/intel-iommu.c~intel-iommu-integrate-dma-cma-fix
+++ a/drivers/iommu/intel-iommu.c
@@ -39,6 +39,7 @@
 #include <linux/dmi.h>
 #include <linux/pci-ats.h>
 #include <linux/memblock.h>
+#include <linux/dma-contiguous.h>
 #include <asm/irq_remapping.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

x86-make-dma_alloc_coherent-return-zeroed-memory-if-cma-is-enabled.patch
x86-make-dma_alloc_coherent-return-zeroed-memory-if-cma-is-enabled-fix.patch
x86-enable-dma-cma-with-swiotlb.patch
intel-iommu-integrate-dma-cma.patch
intel-iommu-integrate-dma-cma-fix.patch
memblock-introduce-memblock_alloc_range.patch
cma-add-placement-specifier-for-cma=-kernel-parameter.patch
arch-x86-kernel-pci-dmac-fix-dma_generic_alloc_coherent-when-config_dma_cma-is-enabled.patch
linux-next.patch

