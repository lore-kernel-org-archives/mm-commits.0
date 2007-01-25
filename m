From: akpm@osdl.org
Subject: + amba-pl010-add-reference-to-ep93xx-to-kconfig-help-entry.patch added to -mm tree
Date: Wed, 24 Jan 2007 20:28:59 -0800
Message-ID: <200701250428.l0P4SxE6005785@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46203 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933204AbXAYE3Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 23:29:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: buytenh@wantstofly.org, rmk@arm.linux.org.uk


The patch titled
     amba-pl010: add reference to ep93xx to Kconfig help entry
has been added to the -mm tree.  Its filename is
     amba-pl010-add-reference-to-ep93xx-to-kconfig-help-entry.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: amba-pl010: add reference to ep93xx to Kconfig help entry
From: Lennert Buytenhek <buytenh@wantstofly.org>

Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/serial/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/serial/Kconfig~amba-pl010-add-reference-to-ep93xx-to-kconfig-help-entry drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~amba-pl010-add-reference-to-ep93xx-to-kconfig-help-entry
+++ a/drivers/serial/Kconfig
@@ -272,7 +272,8 @@ config SERIAL_AMBA_PL010
 	select SERIAL_CORE
 	help
 	  This selects the ARM(R) AMBA(R) PrimeCell PL010 UART.  If you have
-	  an Integrator/AP or Integrator/PP2 platform, say Y or M here.
+	  an Integrator/AP or Integrator/PP2 platform, or if you have a
+	  Cirrus Logic EP93xx CPU, say Y or M here.
 
 	  If unsure, say N.
 
_

Patches currently in -mm which might be from buytenh@wantstofly.org are

amba-pl010-add-reference-to-ep93xx-to-kconfig-help-entry.patch
git-arm.patch
