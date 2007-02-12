From: akpm@linux-foundation.org
Subject: - amba-pl010-add-reference-to-ep93xx-to-kconfig-help-entry.patch removed from -mm tree
Date: Sun, 11 Feb 2007 23:11:06 -0800
Message-ID: <200702120711.l1C7B6JD024549@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44333 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933053AbXBLHL7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 02:11:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: buytenh@wantstofly.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     amba-pl010: add reference to ep93xx to Kconfig help entry
has been removed from the -mm tree.  Its filename was
     amba-pl010-add-reference-to-ep93xx-to-kconfig-help-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: amba-pl010: add reference to ep93xx to Kconfig help entry
From: Lennert Buytenhek <buytenh@wantstofly.org>

Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/serial/Kconfig~amba-pl010-add-reference-to-ep93xx-to-kconfig-help-entry drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~amba-pl010-add-reference-to-ep93xx-to-kconfig-help-entry
+++ a/drivers/serial/Kconfig
@@ -262,7 +262,8 @@ config SERIAL_AMBA_PL010
 	select SERIAL_CORE
 	help
 	  This selects the ARM(R) AMBA(R) PrimeCell PL010 UART.  If you have
-	  an Integrator/AP or Integrator/PP2 platform, say Y or M here.
+	  an Integrator/AP or Integrator/PP2 platform, or if you have a
+	  Cirrus Logic EP93xx CPU, say Y or M here.
 
 	  If unsure, say N.
 
_

Patches currently in -mm which might be from buytenh@wantstofly.org are

git-mtd.patch
