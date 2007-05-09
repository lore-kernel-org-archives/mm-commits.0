From: akpm@linux-foundation.org
Subject: - char-cyclades-depends-on-pci-or-isa.patch removed from -mm tree
Date: Tue, 08 May 2007 19:57:26 -0700
Message-ID: <200705090257.l492vQdR010191@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032779AbXEIC53 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:57:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, depends on PCI or ISA
has been removed from the -mm tree.  Its filename was
     char-cyclades-depends-on-pci-or-isa.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, depends on PCI or ISA
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/Kconfig~char-cyclades-depends-on-pci-or-isa drivers/char/Kconfig
--- a/drivers/char/Kconfig~char-cyclades-depends-on-pci-or-isa
+++ a/drivers/char/Kconfig
@@ -127,7 +127,7 @@ config ROCKETPORT
 
 config CYCLADES
 	tristate "Cyclades async mux support"
-	depends on SERIAL_NONSTANDARD
+	depends on SERIAL_NONSTANDARD && (PCI || ISA)
 	---help---
 	  This driver supports Cyclades Z and Y multiserial boards.
 	  You would need something like this to connect more than two modems to
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
