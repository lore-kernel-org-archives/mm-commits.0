From: akpm@linux-foundation.org
Subject: [merged] edac-amd8131-driver-kconfig-makefile.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:36:57 -0700
Message-ID: <200904061936.n36Javqv012727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757758AbZDFTj2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:39:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qingtao.cao@windriver.com, norsk5@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     edac: AMD8131 driver Kconfig & Makefile
has been removed from the -mm tree.  Its filename was
     edac-amd8131-driver-kconfig-makefile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: AMD8131 driver Kconfig & Makefile
From: Harry Ciao <qingtao.cao@windriver.com>

Introduce Kconfig and Makefile options for AMD8131 EDAC driver.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Kconfig |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/edac/Kconfig~edac-amd8131-driver-kconfig-makefile drivers/edac/Kconfig
--- a/drivers/edac/Kconfig~edac-amd8131-driver-kconfig-makefile
+++ a/drivers/edac/Kconfig
@@ -190,4 +190,11 @@ config EDAC_PPC4XX
 	  PowerPC 4xx embedded processors such as the 405EX[r],
 	  440SP, 440SPe, 460EX, 460GT and 460SX.
 
+config EDAC_AMD8131
+	tristate "AMD8131 HyperTransport PCI-X Tunnel"
+	depends on EDAC_MM_EDAC && PCI
+	help
+	  Support for error detection and correction on the
+	  AMD8131 HyperTransport PCI-X Tunnel chip.
+
 endif # EDAC
_

Patches currently in -mm which might be from qingtao.cao@windriver.com are

origin.patch

