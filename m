From: akpm@linux-foundation.org
Subject: [merged] powerpc-enable-arch_dma_addr_t_64bit-with-arch_phys_addr_t_64bit.patch removed from -mm tree
Date: Tue, 30 Nov 2010 12:05:01 -0800
Message-ID: <201011302005.oAUK5dG1007365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756605Ab0K3UFt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Nov 2010 15:05:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: enable ARCH_DMA_ADDR_T_64BIT with ARCH_PHYS_ADDR_T_64BIT
has been removed from the -mm tree.  Its filename was
     powerpc-enable-arch_dma_addr_t_64bit-with-arch_phys_addr_t_64bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: enable ARCH_DMA_ADDR_T_64BIT with ARCH_PHYS_ADDR_T_64BIT
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/powerpc/Kconfig~powerpc-enable-arch_dma_addr_t_64bit-with-arch_phys_addr_t_64bit arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~powerpc-enable-arch_dma_addr_t_64bit-with-arch_phys_addr_t_64bit
+++ a/arch/powerpc/Kconfig
@@ -16,6 +16,9 @@ config WORD_SIZE
 config ARCH_PHYS_ADDR_T_64BIT
        def_bool PPC64 || PHYS_64BIT
 
+config ARCH_DMA_ADDR_T_64BIT
+	def_bool ARCH_PHYS_ADDR_T_64BIT
+
 config MMU
 	bool
 	default y
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
mips-enable-arch_dma_addr_t_64bit-with-highmem-64bit_phys_addr-64bit.patch
add-the-common-dma_addr_t-typedef-to-include-linux-typesh.patch
remove-dma64_addr_t.patch

