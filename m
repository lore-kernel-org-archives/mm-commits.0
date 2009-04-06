From: akpm@linux-foundation.org
Subject: [merged] edac-remove-edacs-experimental-status.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:36:40 -0700
Message-ID: <200904061936.n36Jaeir012560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751889AbZDFTiD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:38:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac: remove EDAC's experimental status
has been removed from the -mm tree.  Its filename was
     edac-remove-edacs-experimental-status.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: remove EDAC's experimental status
From: Doug Thompson <dougthompson@xmission.com>

After 3 years, this is a patch to remove the EXPERIMENTAL tag on EDAC.  We
now have many module drivers submitters in EDAC and believe EDAC is no
longer EXPERIMENTAL

Signed-off-by: Doug Thompson <dougthompson@xmission.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Kconfig |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/edac/Kconfig~edac-remove-edacs-experimental-status drivers/edac/Kconfig
--- a/drivers/edac/Kconfig~edac-remove-edacs-experimental-status
+++ a/drivers/edac/Kconfig
@@ -1,13 +1,12 @@
 #
 #	EDAC Kconfig
-#	Copyright (c) 2003 Linux Networx
+#	Copyright (c) 2008 Doug Thompson www.softwarebitmaker.com
 #	Licensed and distributed under the GPL
 #
 
 menuconfig EDAC
-	bool "EDAC - error detection and reporting (EXPERIMENTAL)"
+	bool "EDAC - error detection and reporting"
 	depends on HAS_IOMEM
-	depends on EXPERIMENTAL
 	depends on X86 || PPC
 	help
 	  EDAC is designed to report errors in the core system.
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
linux-next.patch

