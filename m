From: akpm@linux-foundation.org
Subject: + ia64-enable-arch_dma_addr_t_64bit.patch added to -mm tree
Date: Fri, 03 Sep 2010 15:10:08 -0700
Message-ID: <201009032210.o83MA8vC015273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756219Ab0ICWKp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 18:10:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, tony.luck@intel.com


The patch titled
     ia64: enable ARCH_DMA_ADDR_T_64BIT
has been added to the -mm tree.  Its filename is
     ia64-enable-arch_dma_addr_t_64bit.patch

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
Subject: ia64: enable ARCH_DMA_ADDR_T_64BIT
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/ia64/Kconfig~ia64-enable-arch_dma_addr_t_64bit arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~ia64-enable-arch_dma_addr_t_64bit
+++ a/arch/ia64/Kconfig
@@ -53,6 +53,9 @@ config MMU
 	bool
 	default y
 
+config ARCH_DMA_ADDR_T_64BIT
+	def_bool y
+
 config NEED_DMA_MAP_STATE
 	def_bool y
 
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
x86-enable-arch_dma_addr_t_64bit-with-x86_64-highmem64g.patch
alpha-enable-arch_dma_addr_t_64bit.patch
ia64-enable-arch_dma_addr_t_64bit.patch
mips-enable-arch_dma_addr_t_64bit-with-highmem-64bit_phys_addr-64bit.patch
powerpc-enable-arch_dma_addr_t_64bit-with-arch_phys_addr_t_64bit.patch
s390-enable-arch_dma_addr_t_64bit-with-64bit.patch
tile-enable-arch_dma_addr_t_64bit.patch
add-the-common-dma_addr_t-typedef-to-include-linux-typesh.patch

