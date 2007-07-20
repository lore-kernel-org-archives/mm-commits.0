From: akpm@linux-foundation.org
Subject: + toshiba_fir-depends-on-virt_to_bus.patch added to -mm tree
Date: Thu, 19 Jul 2007 23:16:41 -0700
Message-ID: <200707200616.l6K6Gf04011037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40048 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754596AbXGTGRl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 02:17:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, davem@davemloft.net, samuel@sortiz.org


The patch titled
     TOSHIBA_FIR depends on virt_to_bus
has been added to the -mm tree.  Its filename is
     toshiba_fir-depends-on-virt_to_bus.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
dpt_i2o-depends-on-virt_to_bus.patch
toshiba_fir-depends-on-virt_to_bus.patch
stradis-and-zoran-depend-on-virt_to_bus.patch
git-kbuild.patch
