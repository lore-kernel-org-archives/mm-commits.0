From: akpm@linux-foundation.org
Subject: [folded-merged] intel-iommu-integrate-dma-cma-fix.patch removed
 from -mm tree
Date: Wed, 04 Jun 2014 15:23:11 -0700
Message-ID: <538f9c4f.vlAObQXJ9ZjqtQZA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbaFDWXM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:23:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, akinobu.mita@gmail.com

Subject: [folded-merged] intel-iommu-integrate-dma-cma-fix.patch removed from -mm tree
To: akinobu.mita@gmail.com,fengguang.wu@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:23:11 -0700


The patch titled
     Subject: intel-iommu: add missing include of dma-contiguous.h
has been removed from the -mm tree.  Its filename was
     intel-iommu-integrate-dma-cma-fix.patch

This patch was dropped because it was folded into intel-iommu-integrate-dma-cma.patch

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

origin.patch
x86-make-dma_alloc_coherent-return-zeroed-memory-if-cma-is-enabled.patch
x86-enable-dma-cma-with-swiotlb.patch
intel-iommu-integrate-dma-cma.patch
memblock-introduce-memblock_alloc_range.patch
cma-add-placement-specifier-for-cma=-kernel-parameter.patch
arch-x86-kernel-pci-dmac-fix-dma_generic_alloc_coherent-when-config_dma_cma-is-enabled.patch

