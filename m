From: akpm@linux-foundation.org
Subject: - blackfin-arch-balance-parenthesis-in-macros.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:09:35 -0700
Message-ID: <200704301909.l3UJ9a1p012334@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946665AbXD3TKS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:10:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     blackfin: balance parenthesis in macros
has been removed from the -mm tree.  Its filename was
     blackfin-arch-balance-parenthesis-in-macros.patch

This patch was dropped because it was folded into blackfin-arch.patch

------------------------------------------------------
Subject: blackfin: balance parenthesis in macros
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Balance parenthesis in blackfin header files.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-blackfin/mach-bf535/bf535.h |    4 ++--
 include/asm-blackfin/scatterlist.h      |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/asm-blackfin/mach-bf535/bf535.h~blackfin-arch-balance-parenthesis-in-macros include/asm-blackfin/mach-bf535/bf535.h
--- a/include/asm-blackfin/mach-bf535/bf535.h~blackfin-arch-balance-parenthesis-in-macros
+++ a/include/asm-blackfin/mach-bf535/bf535.h
@@ -224,7 +224,7 @@
 #define UART0_LSR_TEMT			0x40	/* TSR and UARTx_thr both empty */
 
 #define UART0_MSR_ADDR		0xffc0180c	/* UART 0 Modem status register  16 bit */
-#define UART0_MSR			HALFWORD_REF(UART0_MSR_ADDR
+#define UART0_MSR			HALFWORD_REF(UART0_MSR_ADDR)
 #define UART0_SCR_ADDR		0xffc0180e	/* UART 0 Scratch register  16 bit */
 #define UART0_SCR			HALFWORD_REF(UART0_SCR_ADDR)
 #define UART0_IRCR_ADDR		0xffc01810	/* UART 0 IrDA Control register  16 bit */
@@ -331,7 +331,7 @@
 #define UART1_LSR_TEMT          0x40	/* TSR and UARTx_thr both empty */
 
 #define UART1_MSR_ADDR		0xffc01c0c	/* UART 1 Modem status register  16 bit */
-#define UART1_MSR			HALFWORD_REF(UART1_MSR_ADDR
+#define UART1_MSR			HALFWORD_REF(UART1_MSR_ADDR)
 #define UART1_SCR_ADDR		0xffc01c0e	/* UART 1 Scratch register  16 bit */
 #define UART1_SCR			HALFWORD_REF(UART1_SCR_ADDR)
 
diff -puN include/asm-blackfin/scatterlist.h~blackfin-arch-balance-parenthesis-in-macros include/asm-blackfin/scatterlist.h
--- a/include/asm-blackfin/scatterlist.h~blackfin-arch-balance-parenthesis-in-macros
+++ a/include/asm-blackfin/scatterlist.h
@@ -17,7 +17,7 @@ struct scatterlist {
  * returns, or alternatively stop on the first sg_dma_len(sg) which
  * is 0.
  */
-#define sg_address(sg) (page_address((sg)->page) + (sg)->offset
+#define sg_address(sg) (page_address((sg)->page) + (sg)->offset)
 #define sg_dma_address(sg)      ((sg)->dma_address)
 #define sg_dma_len(sg)          ((sg)->length)
 
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

git-powerpc.patch
blackfin-arch.patch
blackfin-arch-balance-parenthesis-in-macros.patch
