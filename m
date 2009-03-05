From: akpm@linux-foundation.org
Subject: + m68knommu-m532x-build-fix.patch added to -mm tree
Date: Thu, 05 Mar 2009 14:25:20 -0800
Message-ID: <200903052225.n25MPK16008328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755356AbZCEWZc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Mar 2009 17:25:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfking@fdwdc.com, gerg@snapgear.com


The patch titled
     m68knommu: m532x build fix
has been added to the -mm tree.  Its filename is
     m68knommu-m532x-build-fix.patch

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
m68knommu-m532x-build-fix.patch

