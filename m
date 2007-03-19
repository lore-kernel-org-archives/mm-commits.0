From: akpm@linux-foundation.org
Subject: - powerpc-8xx-parenthesis-balance.patch removed from -mm tree
Date: Mon, 19 Mar 2007 14:04:08 -0800
Message-ID: <200703192204.l2JM48DO018928@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58757 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030703AbXCSWEQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 18:04:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, benh@kernel.crashing.org, galak@gate.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: 8xx parenthesis balance
has been removed from the -mm tree.  Its filename was
     powerpc-8xx-parenthesis-balance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-powerpc.patch
blackfin-arch-balance-parenthesis-in-macros.patch
