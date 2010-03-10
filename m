From: akpm@linux-foundation.org
Subject: [folded] dma-mappingh-add-the-dma_unmap-state-api-fix-2.patch removed from -mm tree
Date: Wed, 10 Mar 2010 15:02:36 -0800
Message-ID: <201003102302.o2AN2aVd009126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757385Ab0CJXDN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 18:03:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     dma-mappingh-add-the-dma_unmap-state-api-fix-2
has been removed from the -mm tree.  Its filename was
     dma-mappingh-add-the-dma_unmap-state-api-fix-2.patch

This patch was dropped because it was folded into dma-mappingh-add-the-dma_unmap-state-api.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mappingh-add-the-dma_unmap-state-api-fix-2
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

fix DECLARE_DMA_UNMAP_ADD_ADDR typo with CONFIG_NEED_DMA_MAP_STATE disabled

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-mapping.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/dma-mapping.h~dma-mappingh-add-the-dma_unmap-state-api-fix-2 include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-mappingh-add-the-dma_unmap-state-api-fix-2
+++ a/include/linux/dma-mapping.h
@@ -240,7 +240,7 @@ struct dma_attrs;
 #define dma_unmap_len(PTR, LEN_NAME)             ((PTR)->LEN_NAME)
 #define dma_unmap_len_set(PTR, LEN_NAME, VAL)    (((PTR)->LEN_NAME) = (VAL))
 #else
-#define DEFINE_DMA_MAP_ADDR(ADDR_NAME)
+#define DEFINE_DMA_UNMAP_ADDR(ADDR_NAME)
 #define DEFINE_DMA_UNMAP_LEN(LEN_NAME)
 #define dma_unmap_addr(PTR, ADDR_NAME)           (0)
 #define dma_unmap_addr_set(PTR, ADDR_NAME, VAL)  do { } while (0)
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

documentation-dma-apitxt-remove-deprecated-function-descriptions.patch
dma-apitxt-add-dma_sync_single-sg-api-description.patch
dma-apitxt-remove-dma_sync_single_range-description.patch
alpha-remove-dma_sync_single_range.patch
um-remove-dma_sync_single_range.patch
pci-dma-add-include-linux-pci-dmah.patch
pci-dma-x86-use-include-linux-pci-dmah.patch
pci-dma-alpha-use-include-linux-pci-dmah.patch
pci-dma-arm-use-include-linux-pci-dmah.patch
pci-dma-frv-use-include-linux-pci-dmah.patch
pci-dma-ia64-use-include-linux-pci-dmah.patch
pci-dma-mips-use-include-linux-pci-dmah.patch
pci-dma-parisc-use-include-linux-pci-dmah.patch
pci-dma-powerpc-use-include-linux-pci-dmah.patch
pci-dma-sh-use-include-linux-pci-dmah.patch
pci-dma-sparc-use-include-linux-pci-dmah.patch
pci-dma-xtensa-use-include-linux-pci-dmah.patch
pci-dma-cris-use-include-linux-pci-dmah.patch
pci-dma-add-linux-pci-dmah-to-linux-pcih.patch
dma-mappingh-add-the-dma_unmap-state-api.patch
dma-mappingh-add-the-dma_unmap-state-api-fix-2.patch
frv-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
frv-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
blackfin-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
dma-mapping-sparc-unify-32bit-and-64bit-dma_set_mask.patch
dma-mapping-alpha-use-include-linux-pci-dma-compath.patch
dma-mapping-pci-convert-pci_set_dma_mask-to-call-dma_set_mask.patch
dma-mapping-dma-mappingh-add-dma_set_coherent_mask.patch
dma-mapping-powerpc-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch
dma-mapping-arm-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch
dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath.patch
dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath-fix.patch
documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api.patch
documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api-fix.patch
documentation-remove-the-pci-dma-api-description-in-dma-apitxt.patch
documentation-rename-pci-dma-mappingtxt-to-dma-api-howtotxt.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
documentation-fix-block-biodoctxt-dma-mapping-description.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch

