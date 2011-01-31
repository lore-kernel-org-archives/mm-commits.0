From: akpm@linux-foundation.org
Subject: [merged] mips-enable-arch_dma_addr_t_64bit-with-highmem-64bit_phys_addr-64bit.patch removed from -mm tree
Date: Mon, 31 Jan 2011 11:14:43 -0800
Message-ID: <201101311914.p0VJEhZx027715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753429Ab1AaTPI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Jan 2011 14:15:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips: enable ARCH_DMA_ADDR_T_64BIT with (HIGHMEM && 64BIT_PHYS_ADDR) || 64BIT
has been removed from the -mm tree.  Its filename was
     mips-enable-arch_dma_addr_t_64bit-with-highmem-64bit_phys_addr-64bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mips: enable ARCH_DMA_ADDR_T_64BIT with (HIGHMEM && 64BIT_PHYS_ADDR) || 64BIT
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/mips/Kconfig~mips-enable-arch_dma_addr_t_64bit-with-highmem-64bit_phys_addr-64bit arch/mips/Kconfig
--- a/arch/mips/Kconfig~mips-enable-arch_dma_addr_t_64bit-with-highmem-64bit_phys_addr-64bit
+++ a/arch/mips/Kconfig
@@ -840,6 +840,9 @@ config GPIO_TXX9
 config CFE
 	bool
 
+config ARCH_DMA_ADDR_T_64BIT
+	def_bool (HIGHMEM && 64BIT_PHYS_ADDR) || 64BIT
+
 config DMA_COHERENT
 	bool
 
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
add-the-common-dma_addr_t-typedef-to-include-linux-typesh.patch
remove-dma64_addr_t.patch

