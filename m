From: akpm@linux-foundation.org
Subject: + powerpc-8xx-parenthesis-balance.patch added to -mm tree
Date: Sat, 17 Mar 2007 23:35:44 -0800
Message-ID: <200703180735.l2I7ZiVi018140@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58379 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbXCRHfy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 03:35:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, benh@kernel.crashing.org, galak@gate.crashing.org, paulus@samba.org


The patch titled
     powerpc: 8xx parenthesis balance
has been added to the -mm tree.  Its filename is
     powerpc-8xx-parenthesis-balance.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: powerpc: 8xx parenthesis balance
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Balance parenthesis in powerpc 8xx header files.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/8xx/mpc86xads.h |    2 +-
 arch/powerpc/platforms/8xx/mpc885ads.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/platforms/8xx/mpc86xads.h~powerpc-8xx-parenthesis-balance arch/powerpc/platforms/8xx/mpc86xads.h
--- a/arch/powerpc/platforms/8xx/mpc86xads.h~powerpc-8xx-parenthesis-balance
+++ a/arch/powerpc/platforms/8xx/mpc86xads.h
@@ -37,7 +37,7 @@
 #define CPM_MAP_ADDR		(get_immrbase() + MPC8xx_CPM_OFFSET)
 #define CPM_IRQ_OFFSET		16     // for compability with cpm_uart driver
 
-#define PCMCIA_MEM_ADDR		(uint)0xff020000)
+#define PCMCIA_MEM_ADDR		((uint)0xff020000)
 #define PCMCIA_MEM_SIZE		((uint)(64 * 1024))
 
 /* Bits of interest in the BCSRs.
diff -puN arch/powerpc/platforms/8xx/mpc885ads.h~powerpc-8xx-parenthesis-balance arch/powerpc/platforms/8xx/mpc885ads.h
--- a/arch/powerpc/platforms/8xx/mpc885ads.h~powerpc-8xx-parenthesis-balance
+++ a/arch/powerpc/platforms/8xx/mpc885ads.h
@@ -37,7 +37,7 @@
 #define CPM_MAP_ADDR		(get_immrbase() + MPC8xx_CPM_OFFSET)
 #define CPM_IRQ_OFFSET		16     // for compability with cpm_uart driver
 
-#define PCMCIA_MEM_ADDR		(uint)0xff020000)
+#define PCMCIA_MEM_ADDR		((uint)0xff020000)
 #define PCMCIA_MEM_SIZE		((uint)(64 * 1024))
 
 /* Bits of interest in the BCSRs.
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

powerpc-8xx-parenthesis-balance.patch
blackfin-arch-balance-parenthesis-in-macros.patch
