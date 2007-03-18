From: akpm@linux-foundation.org
Subject: + blackfin-arch-balance-parenthesis-in-macros.patch added to -mm tree
Date: Sat, 17 Mar 2007 23:34:51 -0800
Message-ID: <200703180734.l2I7YpBX018124@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58322 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119AbXCRHfB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 03:35:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, bryan.wu@analog.com


The patch titled
     blackfin: balance parenthesis in macros
has been added to the -mm tree.  Its filename is
     blackfin-arch-balance-parenthesis-in-macros.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

blackfin-arch-balance-parenthesis-in-macros.patch
