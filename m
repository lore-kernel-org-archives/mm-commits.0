From: akpm@linux-foundation.org
Subject: - toshiba_fir-depends-on-virt_to_bus.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:35:27 -0700
Message-ID: <200707230935.l6N9ZRiV016491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34789 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758378AbXGWJpU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, davem@davemloft.net, samuel@sortiz.org, mm-commits@vger.kernel.org


The patch titled
     TOSHIBA_FIR depends on virt_to_bus
has been removed from the -mm tree.  Its filename was
     toshiba_fir-depends-on-virt_to_bus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: TOSHIBA_FIR depends on virt_to_bus
From: Stephen Rothwell <sfr@canb.auug.org.au>

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Samuel Ortiz <samuel@sortiz.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/irda/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/irda/Kconfig~toshiba_fir-depends-on-virt_to_bus drivers/net/irda/Kconfig
--- a/drivers/net/irda/Kconfig~toshiba_fir-depends-on-virt_to_bus
+++ a/drivers/net/irda/Kconfig
@@ -355,7 +355,7 @@ config WINBOND_FIR
 
 config TOSHIBA_FIR
 	tristate "Toshiba Type-O IR Port"
-	depends on IRDA && PCI && !64BIT
+	depends on IRDA && PCI && !64BIT && VIRT_TO_BUS
 	help
 	  Say Y here if you want to build support for the Toshiba Type-O IR
 	  and Donau oboe chipsets. These chipsets are used by the Toshiba
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

stradis-and-zoran-depend-on-virt_to_bus.patch
