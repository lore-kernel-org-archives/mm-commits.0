From: akpm@linux-foundation.org
Subject: [merged] m68knommu-m532x-build-fix.patch removed from -mm tree
Date: Tue, 10 Mar 2009 11:26:58 -0700
Message-ID: <200903101826.n2AIQwuJ022688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755173AbZCJS2c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Mar 2009 14:28:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfking@fdwdc.com, gerg@snapgear.com, mm-commits@vger.kernel.org


The patch titled
     m68knommu: m532x build fix
has been removed from the -mm tree.  Its filename was
     m68knommu-m532x-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knommu: m532x build fix
From: Steven King <sfking@fdwdc.com>

Signed-off-by: Steven King <sfking@fdwdc.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/m532xsim.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/m68k/include/asm/m532xsim.h~m68knommu-m532x-build-fix arch/m68k/include/asm/m532xsim.h
--- a/arch/m68k/include/asm/m532xsim.h~m68knommu-m532x-build-fix
+++ a/arch/m68k/include/asm/m532xsim.h
@@ -16,6 +16,7 @@
 #define MCFINT_VECBASE      64
 #define MCFINT_UART0        26          /* Interrupt number for UART0 */
 #define MCFINT_UART1        27          /* Interrupt number for UART1 */
+#define MCFINT_UART2        28          /* Interrupt number for UART2 */
 
 #define MCF_WTM_WCR	MCF_REG16(0xFC098000)
 
_

Patches currently in -mm which might be from sfking@fdwdc.com are

m68knommu-m5206e-build-fix.patch
m68knommu-m528x-build-fix.patch

