From: akpm@linux-foundation.org
Subject: - mtd-maps-document-mtd_physmap-module-name-in-kconfig.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:41:00 -0700
Message-ID: <200804261641.m3QGf05l031075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756305AbYDZQlr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:41:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd maps: document MTD_PHYSMAP module name in kconfig
has been removed from the -mm tree.  Its filename was
     mtd-maps-document-mtd_physmap-module-name-in-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd maps: document MTD_PHYSMAP module name in kconfig
From: Mike Frysinger <vapier@gentoo.org>

Help out users by telling them the module name in the Kconfig help when
using the MTD_PHYSMAP option.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/mtd/maps/Kconfig~mtd-maps-document-mtd_physmap-module-name-in-kconfig drivers/mtd/maps/Kconfig
--- a/drivers/mtd/maps/Kconfig~mtd-maps-document-mtd_physmap-module-name-in-kconfig
+++ a/drivers/mtd/maps/Kconfig
@@ -21,6 +21,9 @@ config MTD_PHYSMAP
 	  particular board as well as the bus width, either statically
 	  with config options or at run-time.
 
+	  To compile this driver as a module, choose M here: the
+	  module will be called physmap.
+
 config MTD_PHYSMAP_START
 	hex "Physical start address of flash mapping"
 	depends on MTD_PHYSMAP
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
remove-duplicated-unlikely-in-is_err.patch

